module bech32;

import std::collections::list, std::core::dstring;

def CharArray = List(<char>) @private;

struct Decoded {
    String prefix;
    char[] words;
}

const ENCODING_BECH32 = 1;
const ENCODING_BECH32M = 0x2bc830a3;

const ALPHABET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

fault Error {
    BECH32_UNKOWN_CHARACTER,
    BECH32_INVALID_CHECKSUM,
    BECH32_MISSING_PREFIX,
    BECH32_SEPARATOR_CHARACTER_NOT_FOUND,
    BECH32_MIXED_CASE_STRING_NOT_ALLOWED,
    BECH32_TOO_SHORT,
    BECH32_DATA_TOO_SHORT,
    BECH32_NON_5BIT_WORD,
    BECH32_EXCEEDS_LENGTH_LIMIT,
    BECH32_INVALID_PREFIX,
    BECH32_EXCESS_PADDING,
    BECH32_NON_ZERO_PADDING
}

fn int polymod_step(int pre) @private {
    int b = pre >> 25;

    return (
        ((pre & 0x1ffffff) << 5) ^
        (-((b >> 0) & 1) & 0x3b6a57b2) ^
        (-((b >> 1) & 1) & 0x26508e6d) ^
        (-((b >> 2) & 1) & 0x1ea119fa) ^
        (-((b >> 3) & 1) & 0x3d4233dd) ^
        (-((b >> 4) & 1) & 0x2a1462b3)
    );
}

fn int! prefix_chk(String prefix) @private {
    int chk = 1;
    for (int i = 0; i < prefix.len; ++i) {
        char c = prefix[i];
        if (c < 33 || c > 126) {
            return Error.BECH32_INVALID_PREFIX?;
        }
        chk = polymod_step(chk) ^ (c >> 5);
    }
    chk = polymod_step(chk);

    for (int i = 0; i < prefix.len; ++i) {
        char v = prefix[i];
        chk = polymod_step(chk) ^ (v & 0x1f);
    }
    return chk;
}

fn char[]! convert(char[] data, int inBits, int outBits, bool pad) @private {
    int value = 0;
    int bits = 0;
    int maxV = (1 << outBits) - 1;

    CharArray result;

    for (char i = 0; i < data.len; ++i) {
        value = (value << inBits) | data[i];
        bits += inBits;

        while (bits >= outBits) {
            bits -= outBits;
            int t = (value >> bits) & maxV;
            result.push((char)t);
        }
    }

    if (pad) {
        if (bits > 0) {
            int t = (value << (outBits - bits)) & maxV;
            result.push((char)t);
        }
    } else {
        if (bits >= inBits) {
            return Error.BECH32_EXCESS_PADDING?;
        }
        int t = (value << (outBits - bits)) & maxV;
        if (t) {
            return Error.BECH32_NON_ZERO_PADDING?;
        }
    }

    return result.to_tarray();
}

fn char[]! to_words(char[] bytes){
    return convert(bytes, 8, 5, true);
}

fn char[] from_words_unsafe(char[] words) {
    if(try res = convert(words, 5, 8, false)){
        return res;
    } else {
        return {};
    }
}

fn char[]! from_words(char[] words) {
    return convert(words, 5, 8, false);
}

fn String! __encode(String prefix, char[] words, int limit = 90, int encoding_cost = 1) @private {
    if (prefix.len + 7 + words.len > limit) {
        return Error.BECH32_EXCEEDS_LENGTH_LIMIT?;
    }

    prefix.convert_ascii_to_lower();

    // determine chk mod
    int chk = prefix_chk(prefix)!;

    DString result = dstring::temp_new(prefix);

    result.append("1");

    for (int i = 0; i < words.len; ++i) {
        char x = words[i];
        if (x >> 5 != 0) {
            return Error.BECH32_NON_5BIT_WORD?;
        }
        chk = polymod_step(chk) ^ x;
        result.append(ALPHABET[x]);
    }

    for (int i = 0; i < 6; ++i) {
        chk = polymod_step(chk);
    }
    chk ^= encoding_cost;

    for (int i = 0; i < 6; ++i) {
        int v = (chk >> ((5 - i) * 5)) & 0x1f;
        result.append(ALPHABET[v]);
    }

    return result.str_view();
}

fn ichar get_alphabet_char_idx(char ci) @private {
    foreach(i, c : ALPHABET) {
        if (c == ci) {
            return (ichar)i;
        }
    }
    return -1;
}

fn Decoded*! __decode(String str, int limit = 90, int encoding_cost = 1) @private {
    if (str.len < 8) return Error.BECH32_TOO_SHORT?;
    if (str.len > limit) return Error.BECH32_EXCEEDS_LENGTH_LIMIT?;

    // don't allow mixed case
    String lowered = str.temp_ascii_to_lower();
    String uppered = str.temp_ascii_to_upper();
    if (str != lowered && str != uppered) {
        return Error.BECH32_MIXED_CASE_STRING_NOT_ALLOWED?;
    }
    str = lowered;

    usz! split_idx = str.rindex_of("1");

    if (catch err = split_idx) {
        return Error.BECH32_SEPARATOR_CHARACTER_NOT_FOUND?;
    } else if (split_idx == 0u) {
        return Error.BECH32_MISSING_PREFIX?;
    }

    String prefix = str[0: split_idx];
    String wordChars = str[split_idx + 1 .. str.len - 1];

    if (wordChars.len < 6) { 
        return Error.BECH32_DATA_TOO_SHORT?;
    }

    int chk = prefix_chk(prefix)!;
    
    CharArray words;
    for (int i = 0; i < wordChars.len; ++i) {
        char c = wordChars[i];
        ichar v = get_alphabet_char_idx(c);
        if (v == -1i) {
            return Error.BECH32_UNKOWN_CHARACTER?;
        };
        chk = polymod_step(chk) ^ v;

        // not in the checksum?
        if (i + 6 >= wordChars.len) continue;
        words.push(v);
    }

    if (chk != encoding_cost) {
        return Error.BECH32_INVALID_CHECKSUM?;
    }

    return mem::new(Decoded, { .prefix= prefix, .words= words.to_new_array() });
}

 fn String! bech32_encode(String str, char[] words, int limit = 90){
    return __encode(str, words, limit, ENCODING_BECH32);
 }

fn Decoded* bech32_decode_unsafe(String str, int limit = 90) {
    if(try res = __decode(str, limit, ENCODING_BECH32)){
        return res;
    } else {
        return null;
    }
}

fn Decoded*! bech32_decode(String str, int limit = 90) {
    return __decode(str, limit, ENCODING_BECH32);
}

fn Decoded* bech32m_decode_unsafe(String str, int limit = 90) {
    if(try res = __decode(str, limit, ENCODING_BECH32M)){
        return res;
    } else {
        return null;
    }
}

fn Decoded*! bech32m_decode(String str, int limit = 90) {
    return __decode(str, limit, ENCODING_BECH32M);
}

fn String! bech32m_encode(String str, char[] words, int limit = 90){
    return __encode(str, words, limit, ENCODING_BECH32M);
}
