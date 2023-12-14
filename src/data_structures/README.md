# Data structures
## [Array extension](./src/array_ext.cairo)
A collection of handy functions to help with array manipulation.

## [Byte Appender](./src/byte_appender.cairo)
Enables writing unsigned and signed integers in big and little endian byte order onto data structures that support it. Currently, `Array<u8>` and `ByteArray` are supported. 

For unsigned integers `u16` all the way up to `u512` are supported. Signed values are supported from `i8` up to `i128`. The default implementation uses big endian byte order. To get the little endian representation, add an `_le` to the append call.

Consider the example of writing the Bitcoin 80 byte header since it is simple enough:
```
use alexandria_data_structures::byte_appender::ByteAppender;
use alexandria_data_structures::byte_reader::ByteReader;

// Append
let mut array: Array<u8> = array![];
// NOTE: We could equally use a byte array instead of Array<u8>
// let mut byte_array: ByteArray = Default::default(); 

let version = 1_i32; // strangely a signed int32
let prev_hash = u256{low: 0xabcd, high: 0x1234};
let merkle_root = u256{low: 0xef01, high: 0x5678};
let time = 1698179674_u32; 
let n_bits = 0x30c31b18_u32; 
let nonce = fe9f0864_u32;
array.append_i32_le(version); // little endian
array.append_u256(prev_hash); // big endian
array.append_u256(merkle_root); // big endian
array.append_u32_le(time); // little endian
array.append_u32_le(n_bits); // little endian
array.append_u32_le(nonce); // little endian
```
The Bitcoin header infamously mixes endiannes, allegedly due to how OpenSSL output was used verbatim for the hashes. The array now encodes the bitcoin header byte for byte using the correct endian ordering. Hashing the array should produce the expected block hash result.

## [Byte Reader](./src/byte_reader.cairo)
Reads structured integer data from byte containing data structures. We currently support `ByteArray` and standard byte arrays as `Array<u8>`. Both unsigned and signed integer data is supported. We do not need to worry about offsets or indicies. Data is read from start to finish and if the source data unexpectedly runs out of bytes an `Option::None` is returned instead.

The `ByteReaderState` holds the state necessary to incrementally read structured integers. This can be initialized from the supported data structures by calling `.reader()` on the source data. It needs to be mutable due to how index is incremented with each read.

Big endian byte order is read by default and adding an `_le` suffix to the call, gets the little endian representation. As for the appender unsigned integers up to `u512` are supported as well as signed integers from `i8` to `i128`.

Let us continue with the example above of reading out the Bitcoin header from a serialized byte strean.
```
// input is of type Array<u8> or ByteArray
let mut reader = input.reader();
let version = reader.read_i32_le().unwrap();
let prev_hash = reader.read_u256().unwrap();
let merkle_root = reader.read_u256().unwrap();
let time = reader.read_u32_le().unwrap();
let n_bits = read.read_u32_le().unwrap();
let nonce = reader.read_u32_le().unwrap();
```

## [Queue](./src/queue.cairo)

The queue is used to store and manipulate a collection of elements where the elements are processed in a first-in, first-out (FIFO) order.
The purpose of the queue algorithm is to provide a way to manage and process elements in a specific order, where the oldest element is processed first.
The queue algorithm has applications in various areas of computer science, including operating systems, networking, and data processing. It is used to manage tasks that are processed in a specific order and ensure that the order is maintained.
By providing a simple and efficient way to manage elements in a specific order, the queue algorithm is an important tool in computer science and software development.

## [Stack](./src/stack.cairo)

The stack is used to store and manipulate a collection of elements where the elements are processed in a last-in, first-out (LIFO) order.
The purpose of the stack algorithm is to provide a way to manage and process elements in a specific order, where the most recently added element is processed first.
The stack algorithm has applications in various areas of computer science, including programming languages, operating systems, and network protocols. It is used to manage tasks that require a temporary storage of data or information, and also for processing recursive function calls.
By providing a simple and efficient way to manage elements in a specific order, the stack algorithm is an important tool in computer science and software development.