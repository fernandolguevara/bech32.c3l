# Bech32 for c3

Library ported from bitcoinjs/bech32

## Example

```c++
import bech32;

fn void! main(String[] args) {
{
    Decoded* decoded = bech32::bech32_decode("abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw")!;
    
    assert(decoded.prefix == "abcdef");
    assert(decoded.words == {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31});
    char[] data = bech32::from_words(decoded.words)!;        
    String hex = data.bytes_to_hex();
    assert( hex == "00443214c74254b635cf84653a56d7c675be77df");

    char[] words = bech32::to_words("foobar")!!;
    String b32 = bech32::bech32_encode("foo", words)!!;
    io::printfn("bech32_encode %s", b32);
    assert(b32 == "foo1vehk7cnpwgry9h96");
    String b32m = bech32::bech32m_encode("foo", words)!!;
    assert(b32m == "foo1vehk7cnpwgkc4mqc");
    io::printfn("bech32m_encode %s", b32m);
};
```