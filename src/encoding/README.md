# Encoding

## [Base64](./src/base64.cairo)

Base64 is a binary-to-text encoding scheme used for transferring binary data safely over media designed for text. It divides input data into 3-byte blocks, each converted into 4 ASCII characters using a specific index table. If input bytes aren't divisible by three, it's padded with '=' characters. The process is reversed for decoding.
