# Bytes

Note that:   In Bytes, there are many variables about size and length.We use size to represent the number of bytes in Bytes.We use length to represent the number of elements in Bytes.Bytes is a cairo implementation of solidity Bytes in Big-endian.It is a dynamic array of u128, where each element contains 16 bytes.To save cost, the last element MUST be filled fully.That means that every element should and MUST contain 16 bytes.For example, if we have a Bytes with 33 bytes, we will have 3 elements.Theoretically, the bytes look like this:first element:  [16 bytes](16 bytes)second element: [16 bytes](16 bytes)third element:  [1 byte](1 byte)But in alexandria bytes, the last element should be padded with zero to makeit 16 bytes. So the alexandria bytes look like this:first element:  [16 bytes](16 bytes)second element: [16 bytes](16 bytes)third element:  [1 byte](1 byte) + [15 bytes zero padding](15 bytes zero padding)Bytes is a dynamic array of u128, where each element contains 16 bytes.size: the number of bytes in the Bytesdata: the data of the Bytes

Fully qualified path: `alexandria_bytes::bytes::Bytes`

```rust
#[derive(Drop, Clone, PartialEq)]
pub struct Bytes {
    size: usize,
    data: Array<u128>,
}
```

