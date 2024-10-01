module bench32::test @test;

import bech32; 

fn void! test_bech32() {
    if(try decoded = bech32::bech32_decode("A12UEL5L")){
        assert(decoded.prefix == "a");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }

    if(try decoded = bech32::bech32_decode("an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs")){
        assert(decoded.prefix == "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }

    if(try decoded = bech32::bech32_decode("abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw")){
        assert(decoded.prefix == "abcdef");
        assert(decoded.words == {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31});
        char[] data = bech32::from_words(decoded.words)!;        
        String hex = data.bytes_to_hex();
        assert( hex == "00443214c74254b635cf84653a56d7c675be77df");
    }

    if(try decoded = bech32::bech32_decode("11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j")){
        assert(decoded.prefix == "1");
        assert(decoded.words == {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
        char[] data = bech32::from_words(decoded.words)!;        
        String hex = data.bytes_to_hex();
        assert( hex == "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    }

    if(try decoded = bech32::bech32_decode("split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w")){
        assert(decoded.prefix == "split");
        assert(decoded.words == {24,23,25,24,22,28,1,16,11,29,8,25,23,29,19,13,16,23,29,22,25,28,1,16,11,3,25,29,27,25,3,3,29,19,11,25,3,3,25,13,24,29,1,25,3,3,25,13});
        char[] data = bech32::from_words(decoded.words)!;        
        String hex = data.bytes_to_hex();
        assert( hex == "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d");
    }

    if(try decoded = bech32::bech32_decode("11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq978ear", 300)){
        assert(decoded.prefix == "1");
        assert(decoded.words == {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
        char[] data = bech32::from_words(decoded.words)!;        
        String hex = data.bytes_to_hex();
        assert( hex == "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    }

    if(catch err = bech32::bech32_decode("A12Uel5l")){
        assert(err == Error.BECH32_MIXED_CASE_STRING_NOT_ALLOWED);
    }

    if(catch err = bech32::bech32_decode("\01nwldj5")){
        assert(err == Error.BECH32_INVALID_PREFIX);
    }

    if(catch err = bech32::bech32_decode("abc1rzg")){
        assert(err == Error.BECH32_TOO_SHORT);
    }

    if(catch err = bech32::bech32_decode("an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx")){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32_decode("x1b4n0q5v")){
        assert(err == Error.BECH32_UNKOWN_CHARACTER);
    }

    if(catch err = bech32::bech32_decode("pzry9x0s0muk")){
        assert(err == Error.BECH32_SEPARATOR_CHARACTOR_NOT_FOUND);
    } 

    if(catch err = bech32::bech32_decode("abc1rzgt4")){
        assert(err == Error.BECH32_DATA_TOO_SHORT);
    } 

    if(catch err = bech32::bech32_decode("s1vcsyn")){
        assert(err == Error.BECH32_TOO_SHORT);
    } 

    if(catch err = bech32::bech32_decode("li1dgmt3")){
        assert(err == Error.BECH32_DATA_TOO_SHORT);
    } 

    if(catch err = bech32::bech32_encode("abc", {128})) {
        assert(err == Error.BECH32_NON_5BIT_WORD);
    }

    if(catch err = bech32::bech32_encode("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobar", {128})) {
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32_encode("foobar", {20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20})) {
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32_encode("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobarfoobarfoobar", {128})) {
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32_encode("abc\u00ff", {18})) {
        assert(err == Error.BECH32_INVALID_PREFIX);
    }
}

fn void! test_benc32m() {
    if(try decoded = bech32::bech32m_decode("A1LQFN3A")){
        assert(decoded.prefix == "a");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }

    if(try decoded = bech32::bech32m_decode("a1lqfn3a")){
        assert(decoded.prefix == "a");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }
    
    if(try decoded = bech32::bech32m_decode("an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6")){
        assert(decoded.prefix == "an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber1");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }
    
    if(try decoded = bech32::bech32m_decode("abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx")){
        assert(decoded.prefix == "abcdef");
        assert(decoded.words == {31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "ffbbcdeb38bdab49ca307b9ac5a928398a418820");
    }

    if(try decoded = bech32::bech32m_decode("11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8")){
        assert(decoded.prefix == "1");
        assert(decoded.words == {31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31});
    }

    if(try decoded = bech32::bech32m_decode("split1checkupstagehandshakeupstreamerranterredcaperredlc445v")){
        assert(decoded.prefix == "split");
        assert(decoded.words == {24,23,25,24,22,28,1,16,11,29,8,25,23,29,19,13,16,23,29,22,25,28,1,16,11,3,25,29,27,25,3,3,29,19,11,25,3,3,25,13,24,29,1,25,3,3,25,13});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "c5f38b70305f519bf66d85fb6cf03058f3dde463ecd7918f2dc743918f2d");
    }

    if(try decoded = bech32::bech32m_decode("?1v759aa")){
        assert(decoded.prefix == "?");
        assert(decoded.words == {});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "");
    }

    if(try decoded = bech32::bech32m_decode("11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqszh4cp", 300)){
        assert(decoded.prefix == "1");
        assert(decoded.words == {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
        char[] data = bech32::from_words(decoded.words)!;       
        String hex = data.bytes_to_hex();
        assert( hex == "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    }

    if(catch err = bech32::bech32m_decode("A12Uel5l")){
        assert(err == Error.BECH32_MIXED_CASE_STRING_NOT_ALLOWED);
    }

    if(catch err = bech32::bech32m_decode("\01nwldj5")){
        assert(err == Error.BECH32_INVALID_PREFIX);
    }

    if(catch err = bech32::bech32m_decode("abc1rzg")){
        assert(err == Error.BECH32_TOO_SHORT);
    }

    if(catch err = bech32::bech32m_decode("an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx")){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32m_decode("x1b4n0q5v")){
        assert(err == Error.BECH32_UNKOWN_CHARACTER);
    }

    if(catch err = bech32::bech32m_decode("1pzry9x0s0muk")){
        assert(err == Error.BECH32_MISSING_PREFIX);
    }

    if(catch err = bech32::bech32m_decode("pzry9x0s0muk")){
        assert(err == Error.BECH32_SEPARATOR_CHARACTOR_NOT_FOUND);
    }

    if(catch err = bech32::bech32m_decode("abc1rzgt4")){
        assert(err == Error.BECH32_DATA_TOO_SHORT);
    }

    if(catch err = bech32::bech32m_decode("s1vcsyn")){
        assert(err == Error.BECH32_TOO_SHORT);
    }

    if(catch err = bech32::bech32m_encode("abc", {128})){
        assert(err == Error.BECH32_NON_5BIT_WORD);
    }

    if(catch err = bech32::bech32m_encode("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobar", {128})){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32m_encode("foobar", {20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20})){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32m_encode("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzfoobarfoobarfoobarfoobar", {128})){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }
    
    if(catch err = bech32::bech32m_encode("11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j", {128})){
        assert(err == Error.BECH32_EXCEEDS_LENGTH_LIMIT);
    }

    if(catch err = bech32::bech32m_encode("abc\u00ff", {128})){
        assert(err == Error.BECH32_INVALID_PREFIX);
    }
}