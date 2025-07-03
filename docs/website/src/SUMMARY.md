# Summary

[Introduction](intro.md)

- [Alexandria Ascii](./alexandria_ascii/alexandria_ascii.md)

  - [ToAsciiTrait](./alexandria_ascii/alexandria_ascii-integer-ToAsciiTrait.md)

  - [ToAsciiArrayTrait](./alexandria_ascii/alexandria_ascii-integer-ToAsciiArrayTrait.md)

- [Alexandria Bytes](./alexandria_bytes/alexandria_bytes_info.md)

  - [Modules](./alexandria_bytes/modules.md)

    - [alexandria_bytes](./alexandria_bytes/alexandria_bytes.md)

    - [bit_array](./alexandria_bytes/alexandria_bytes-bit_array.md)

    - [byte_appender](./alexandria_bytes/alexandria_bytes-byte_appender.md)

    - [byte_array_ext](./alexandria_bytes/alexandria_bytes-byte_array_ext.md)

    - [byte_reader](./alexandria_bytes/alexandria_bytes-byte_reader.md)

    - [bytes](./alexandria_bytes/alexandria_bytes-bytes.md)

    - [reversible](./alexandria_bytes/alexandria_bytes-reversible.md)

    - [storage](./alexandria_bytes/alexandria_bytes-storage.md)

    - [utils](./alexandria_bytes/alexandria_bytes-utils.md)

  - [Constants](./alexandria_bytes/constants.md)

    - [BYTES_PER_ELEMENT](./alexandria_bytes/alexandria_bytes-bytes-BYTES_PER_ELEMENT.md)

  - [Free functions](./alexandria_bytes/free_functions.md)

    - [shift_bit](./alexandria_bytes/alexandria_bytes-bit_array-shift_bit.md)

    - [one_shift_left_bytes_felt252](./alexandria_bytes/alexandria_bytes-bit_array-one_shift_left_bytes_felt252.md)

    - [one_shift_left_bytes_u128](./alexandria_bytes/alexandria_bytes-bit_array-one_shift_left_bytes_u128.md)

    - [reversing](./alexandria_bytes/alexandria_bytes-reversible-reversing.md)

    - [reversing_partial_result](./alexandria_bytes/alexandria_bytes-reversible-reversing_partial_result.md)

    - [keccak_u128s_be](./alexandria_bytes/alexandria_bytes-utils-keccak_u128s_be.md)

    - [u256_reverse_endian](./alexandria_bytes/alexandria_bytes-utils-u256_reverse_endian.md)

    - [u8_array_to_u256](./alexandria_bytes/alexandria_bytes-utils-u8_array_to_u256.md)

    - [u32s_to_u256](./alexandria_bytes/alexandria_bytes-utils-u32s_to_u256.md)

    - [u128_array_slice](./alexandria_bytes/alexandria_bytes-utils-u128_array_slice.md)

    - [u128_split](./alexandria_bytes/alexandria_bytes-utils-u128_split.md)

    - [read_sub_u128](./alexandria_bytes/alexandria_bytes-utils-read_sub_u128.md)

    - [u128_join](./alexandria_bytes/alexandria_bytes-utils-u128_join.md)

    - [pad_left_data](./alexandria_bytes/alexandria_bytes-utils-pad_left_data.md)

  - [Structs](./alexandria_bytes/structs.md)

    - [bytes::Bytes](./alexandria_bytes/alexandria_bytes-bytes-Bytes.md)

    - [BitArray](./alexandria_bytes/alexandria_bytes-bit_array-BitArray.md)

    - [ByteReaderState](./alexandria_bytes/alexandria_bytes-byte_reader-ByteReaderState.md)

  - [Traits](./alexandria_bytes/traits.md)

    - [bytes::BytesTrait](./alexandria_bytes/alexandria_bytes-bytes-BytesTrait.md)

    - [BitArrayTrait](./alexandria_bytes/alexandria_bytes-bit_array-BitArrayTrait.md)

    - [ByteAppenderSupportTrait](./alexandria_bytes/alexandria_bytes-byte_appender-ByteAppenderSupportTrait.md)

    - [ByteAppender](./alexandria_bytes/alexandria_bytes-byte_appender-ByteAppender.md)

    - [ByteArrayTraitExt](./alexandria_bytes/alexandria_bytes-byte_array_ext-ByteArrayTraitExt.md)

    - [ByteReader](./alexandria_bytes/alexandria_bytes-byte_reader-ByteReader.md)

    - [ReversibleBytes](./alexandria_bytes/alexandria_bytes-reversible-ReversibleBytes.md)

    - [ReversibleBits](./alexandria_bytes/alexandria_bytes-reversible-ReversibleBits.md)

  - [Impls](./alexandria_bytes/impls.md)

    - [bytes::BytesIndex](./alexandria_bytes/alexandria_bytes-bytes-BytesIndex.md)

    - [storage::BytesStore](./alexandria_bytes/alexandria_bytes-storage-BytesStore.md)

    - [SpanU8IntoBytearray](./alexandria_bytes/alexandria_bytes-byte_array_ext-SpanU8IntoBytearray.md)

    - [ByteArrayIntoArrayU8](./alexandria_bytes/alexandria_bytes-byte_array_ext-ByteArrayIntoArrayU8.md)

    - [ByteArrayTraitExtImpl](./alexandria_bytes/alexandria_bytes-byte_array_ext-ByteArrayTraitExtImpl.md)

    - [ByteArrayAppenderImpl](./alexandria_bytes/alexandria_bytes-byte_array_ext-ByteArrayAppenderImpl.md)

    - [ByteArrayIntoBytes](./alexandria_bytes/alexandria_bytes-bytes-ByteArrayIntoBytes.md)

    - [BytesIntoByteArray](./alexandria_bytes/alexandria_bytes-bytes-BytesIntoByteArray.md)

    - [BytesDebug](./alexandria_bytes/alexandria_bytes-utils-BytesDebug.md)

    - [BytesDisplay](./alexandria_bytes/alexandria_bytes-utils-BytesDisplay.md)

- [Alexandria Encoding](./alexandria_encoding/alexandria_encoding_info.md)

  - [Modules](./alexandria_encoding/modules.md)

    - [alexandria_encoding](./alexandria_encoding/alexandria_encoding.md)

    - [base58](./alexandria_encoding/alexandria_encoding-base58.md)

    - [base64](./alexandria_encoding/alexandria_encoding-base64.md)

    - [rlp](./alexandria_encoding/alexandria_encoding-rlp.md)

    - [rlp_byte_array](./alexandria_encoding/alexandria_encoding-rlp_byte_array.md)

    - [sol_abi](./alexandria_encoding/alexandria_encoding-sol_abi.md)

    - [decode](./alexandria_encoding/alexandria_encoding-sol_abi-decode.md)

    - [encode](./alexandria_encoding/alexandria_encoding-sol_abi-encode.md)

    - [encode_as](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as.md)

    - [sol_bytes](./alexandria_encoding/alexandria_encoding-sol_abi-sol_bytes.md)

  - [Free functions](./alexandria_encoding/free_functions.md)

    - [base58::encode_u8_array](./alexandria_encoding/alexandria_encoding-base58-encode_u8_array.md)

    - [base64::encode_u8_array](./alexandria_encoding/alexandria_encoding-base64-encode_u8_array.md)

    - [encode_felt](./alexandria_encoding/alexandria_encoding-base64-encode_felt.md)

    - [encode_byte_array](./alexandria_encoding/alexandria_encoding-base64-encode_byte_array.md)

  - [Enums](./alexandria_encoding/enums.md)

    - [rlp::RLPError](./alexandria_encoding/alexandria_encoding-rlp-RLPError.md)

    - [rlp::RLPType](./alexandria_encoding/alexandria_encoding-rlp-RLPType.md)

    - [RLPItem](./alexandria_encoding/alexandria_encoding-rlp-RLPItem.md)

    - [rlp_byte_array::RLPError](./alexandria_encoding/alexandria_encoding-rlp_byte_array-RLPError.md)

    - [rlp_byte_array::RLPType](./alexandria_encoding/alexandria_encoding-rlp_byte_array-RLPType.md)

    - [RLPItemByteArray](./alexandria_encoding/alexandria_encoding-rlp_byte_array-RLPItemByteArray.md)

  - [Traits](./alexandria_encoding/traits.md)

    - [base58::Encoder](./alexandria_encoding/alexandria_encoding-base58-Encoder.md)

    - [base58::Decoder](./alexandria_encoding/alexandria_encoding-base58-Decoder.md)

    - [base64::Encoder](./alexandria_encoding/alexandria_encoding-base64-Encoder.md)

    - [base64::Decoder](./alexandria_encoding/alexandria_encoding-base64-Decoder.md)

    - [ByteArrayEncoder](./alexandria_encoding/alexandria_encoding-base64-ByteArrayEncoder.md)

    - [ByteArrayDecoder](./alexandria_encoding/alexandria_encoding-base64-ByteArrayDecoder.md)

    - [rlp::RLPTrait](./alexandria_encoding/alexandria_encoding-rlp-RLPTrait.md)

    - [rlp_byte_array::RLPTrait](./alexandria_encoding/alexandria_encoding-rlp_byte_array-RLPTrait.md)

    - [SolAbiDecodeTrait](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeTrait.md)

    - [SolAbiEncodeSelectorTrait](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeSelectorTrait.md)

    - [SolAbiEncodeTrait](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeTrait.md)

    - [SolAbiEncodeAsTrait](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsTrait.md)

    - [SolBytesTrait](./alexandria_encoding/alexandria_encoding-sol_abi-sol_bytes-SolBytesTrait.md)

  - [Impls](./alexandria_encoding/impls.md)

    - [Base58Encoder](./alexandria_encoding/alexandria_encoding-base58-Base58Encoder.md)

    - [Base58Decoder](./alexandria_encoding/alexandria_encoding-base58-Base58Decoder.md)

    - [Base64Encoder](./alexandria_encoding/alexandria_encoding-base64-Base64Encoder.md)

    - [Base64UrlEncoder](./alexandria_encoding/alexandria_encoding-base64-Base64UrlEncoder.md)

    - [Base64FeltEncoder](./alexandria_encoding/alexandria_encoding-base64-Base64FeltEncoder.md)

    - [Base64UrlFeltEncoder](./alexandria_encoding/alexandria_encoding-base64-Base64UrlFeltEncoder.md)

    - [Base64ByteArrayEncoder](./alexandria_encoding/alexandria_encoding-base64-Base64ByteArrayEncoder.md)

    - [Base64ByteArrayUrlEncoder](./alexandria_encoding/alexandria_encoding-base64-Base64ByteArrayUrlEncoder.md)

    - [Base64Decoder](./alexandria_encoding/alexandria_encoding-base64-Base64Decoder.md)

    - [Base64UrlDecoder](./alexandria_encoding/alexandria_encoding-base64-Base64UrlDecoder.md)

    - [Base64ByteArrayDecoder](./alexandria_encoding/alexandria_encoding-base64-Base64ByteArrayDecoder.md)

    - [rlp::RLPImpl](./alexandria_encoding/alexandria_encoding-rlp-RLPImpl.md)

    - [rlp_byte_array::RLPImpl](./alexandria_encoding/alexandria_encoding-rlp_byte_array-RLPImpl.md)

    - [SolAbiDecodeU8](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU8.md)

    - [SolAbiDecodeU16](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU16.md)

    - [SolAbiDecodeU32](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU32.md)

    - [SolAbiDecodeU64](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU64.md)

    - [SolAbiDecodeU128](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU128.md)

    - [SolAbiDecodeU256](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeU256.md)

    - [SolAbiDecodeBool](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeBool.md)

    - [SolAbiDecodeFelt252](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeFelt252.md)

    - [SolAbiDecodeBytes31](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeBytes31.md)

    - [SolAbiDecodeBytes](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeBytes.md)

    - [SolAbiDecodeByteArray](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeByteArray.md)

    - [SolAbiDecodeStarknetAddress](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeStarknetAddress.md)

    - [SolAbiDecodeEthAddress](./alexandria_encoding/alexandria_encoding-sol_abi-decode-SolAbiDecodeEthAddress.md)

    - [SolAbiEncodeSelector](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeSelector.md)

    - [SolAbiEncodeU8](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU8.md)

    - [SolAbiEncodeU16](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU16.md)

    - [SolAbiEncodeU32](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU32.md)

    - [SolAbiEncodeU64](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU64.md)

    - [SolAbiEncodeU128](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU128.md)

    - [SolAbiEncodeU256](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeU256.md)

    - [SolAbiEncodeBool](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeBool.md)

    - [SolAbiEncodeFelt252](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeFelt252.md)

    - [SolAbiEncodeBytes31](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeBytes31.md)

    - [SolAbiEncodeBytes](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeBytes.md)

    - [SolAbiEncodeByteArray](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeByteArray.md)

    - [SolAbiEncodeStarknetAddress](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeStarknetAddress.md)

    - [SolAbiEncodeEthAddress](./alexandria_encoding/alexandria_encoding-sol_abi-encode-SolAbiEncodeEthAddress.md)

    - [SolAbiEncodeAsU256](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsU256.md)

    - [SolAbiEncodeAsU128](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsU128.md)

    - [SolAbiEncodeAsFelt252](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsFelt252.md)

    - [SolAbiEncodeAsBytes31](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsBytes31.md)

    - [SolAbiEncodeAsBytes](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsBytes.md)

    - [SolAbiEncodeAsByteArray](./alexandria_encoding/alexandria_encoding-sol_abi-encode_as-SolAbiEncodeAsByteArray.md)

- [Alexandria Data Structures](./alexandria_data_structures/alexandria_data_structures_info.md)

  - [Modules](./alexandria_data_structures/modules.md)

    - [alexandria_data_structures](./alexandria_data_structures/alexandria_data_structures.md)

    - [array_ext](./alexandria_data_structures/alexandria_data_structures-array_ext.md)

    - [bit_array](./alexandria_data_structures/alexandria_data_structures-bit_array.md)

    - [byte_appender](./alexandria_data_structures/alexandria_data_structures-byte_appender.md)

    - [byte_array_ext](./alexandria_data_structures/alexandria_data_structures-byte_array_ext.md)

    - [byte_reader](./alexandria_data_structures/alexandria_data_structures-byte_reader.md)

    - [queue](./alexandria_data_structures/alexandria_data_structures-queue.md)

    - [span_ext](./alexandria_data_structures/alexandria_data_structures-span_ext.md)

    - [stack](./alexandria_data_structures/alexandria_data_structures-stack.md)

    - [vec](./alexandria_data_structures/alexandria_data_structures-vec.md)

  - [Free functions](./alexandria_data_structures/free_functions.md)

    - [shift_bit](./alexandria_data_structures/alexandria_data_structures-bit_array-shift_bit.md)

    - [one_shift_left_bytes_felt252](./alexandria_data_structures/alexandria_data_structures-bit_array-one_shift_left_bytes_felt252.md)

    - [one_shift_left_bytes_u128](./alexandria_data_structures/alexandria_data_structures-bit_array-one_shift_left_bytes_u128.md)

    - [reversing](./alexandria_data_structures/alexandria_data_structures-byte_appender-reversing.md)

    - [reversing_partial_result](./alexandria_data_structures/alexandria_data_structures-byte_appender-reversing_partial_result.md)

  - [Structs](./alexandria_data_structures/structs.md)

    - [BitArray](./alexandria_data_structures/alexandria_data_structures-bit_array-BitArray.md)

    - [ByteReaderState](./alexandria_data_structures/alexandria_data_structures-byte_reader-ByteReaderState.md)

    - [Queue](./alexandria_data_structures/alexandria_data_structures-queue-Queue.md)

    - [Felt252Stack](./alexandria_data_structures/alexandria_data_structures-stack-Felt252Stack.md)

    - [NullableStack](./alexandria_data_structures/alexandria_data_structures-stack-NullableStack.md)

    - [Felt252Vec](./alexandria_data_structures/alexandria_data_structures-vec-Felt252Vec.md)

    - [NullableVec](./alexandria_data_structures/alexandria_data_structures-vec-NullableVec.md)

  - [Traits](./alexandria_data_structures/traits.md)

    - [ArrayTraitExt](./alexandria_data_structures/alexandria_data_structures-array_ext-ArrayTraitExt.md)

    - [BitArrayTrait](./alexandria_data_structures/alexandria_data_structures-bit_array-BitArrayTrait.md)

    - [ByteAppenderSupportTrait](./alexandria_data_structures/alexandria_data_structures-byte_appender-ByteAppenderSupportTrait.md)

    - [ByteAppender](./alexandria_data_structures/alexandria_data_structures-byte_appender-ByteAppender.md)

    - [ByteReader](./alexandria_data_structures/alexandria_data_structures-byte_reader-ByteReader.md)

    - [QueueTrait](./alexandria_data_structures/alexandria_data_structures-queue-QueueTrait.md)

    - [SpanTraitExt](./alexandria_data_structures/alexandria_data_structures-span_ext-SpanTraitExt.md)

    - [StackTrait](./alexandria_data_structures/alexandria_data_structures-stack-StackTrait.md)

    - [VecTrait](./alexandria_data_structures/alexandria_data_structures-vec-VecTrait.md)

  - [Impls](./alexandria_data_structures/impls.md)

    - [SpanU8IntoBytearray](./alexandria_data_structures/alexandria_data_structures-byte_array_ext-SpanU8IntoBytearray.md)

    - [ByteArrayIntoArrayU8](./alexandria_data_structures/alexandria_data_structures-byte_array_ext-ByteArrayIntoArrayU8.md)

- [Alexandria Evm](./alexandria_evm/alexandria_evm_info.md)

  - [Modules](./alexandria_evm/modules.md)

    - [alexandria_evm](./alexandria_evm/alexandria_evm.md)

- [Alexandria Linalg](./alexandria_linalg/alexandria_linalg_info.md)

  - [Modules](./alexandria_linalg/modules.md)

    - [alexandria_linalg](./alexandria_linalg/alexandria_linalg.md)

    - [dot](./alexandria_linalg/alexandria_linalg-dot.md)

    - [kron](./alexandria_linalg/alexandria_linalg-kron.md)

    - [norm](./alexandria_linalg/alexandria_linalg-norm.md)

  - [Free functions](./alexandria_linalg/free_functions.md)

    - [dot](./alexandria_linalg/alexandria_linalg-dot-dot.md)

    - [kron](./alexandria_linalg/alexandria_linalg-kron-kron.md)

    - [norm](./alexandria_linalg/alexandria_linalg-norm-norm.md)

  - [Enums](./alexandria_linalg/enums.md)

    - [KronError](./alexandria_linalg/alexandria_linalg-kron-KronError.md)

- [Alexandria Math](./alexandria_math/alexandria_math_info.md)

  - [Modules](./alexandria_math/modules.md)

    - [alexandria_math](./alexandria_math/alexandria_math.md)

    - [aliquot_sum](./alexandria_math/alexandria_math-aliquot_sum.md)

    - [armstrong_number](./alexandria_math/alexandria_math-armstrong_number.md)

    - [bip340](./alexandria_math/alexandria_math-bip340.md)

    - [bitmap](./alexandria_math/alexandria_math-bitmap.md)

    - [collatz_sequence](./alexandria_math/alexandria_math-collatz_sequence.md)

    - [const_pow](./alexandria_math/alexandria_math-const_pow.md)

    - [ed25519](./alexandria_math/alexandria_math-ed25519.md)

    - [extended_euclidean_algorithm](./alexandria_math/alexandria_math-extended_euclidean_algorithm.md)

    - [fast_power](./alexandria_math/alexandria_math-fast_power.md)

    - [fast_root](./alexandria_math/alexandria_math-fast_root.md)

    - [fibonacci](./alexandria_math/alexandria_math-fibonacci.md)

    - [gcd_of_n_numbers](./alexandria_math/alexandria_math-gcd_of_n_numbers.md)

    - [i257](./alexandria_math/alexandria_math-i257.md)

    - [is_power_of_two](./alexandria_math/alexandria_math-is_power_of_two.md)

    - [is_prime](./alexandria_math/alexandria_math-is_prime.md)

    - [karatsuba](./alexandria_math/alexandria_math-karatsuba.md)

    - [keccak256](./alexandria_math/alexandria_math-keccak256.md)

    - [lcm_of_n_numbers](./alexandria_math/alexandria_math-lcm_of_n_numbers.md)

    - [mod_arithmetics](./alexandria_math/alexandria_math-mod_arithmetics.md)

    - [perfect_number](./alexandria_math/alexandria_math-perfect_number.md)

    - [sha256](./alexandria_math/alexandria_math-sha256.md)

    - [sha512](./alexandria_math/alexandria_math-sha512.md)

    - [trigonometry](./alexandria_math/alexandria_math-trigonometry.md)

    - [u512_arithmetics](./alexandria_math/alexandria_math-u512_arithmetics.md)

    - [wad_ray_math](./alexandria_math/alexandria_math-wad_ray_math.md)

    - [zellers_congruence](./alexandria_math/alexandria_math-zellers_congruence.md)

  - [Constants](./alexandria_math/constants.md)

    - [p](./alexandria_math/alexandria_math-ed25519-p.md)

    - [p_non_zero](./alexandria_math/alexandria_math-ed25519-p_non_zero.md)

    - [p2x](./alexandria_math/alexandria_math-ed25519-p2x.md)

    - [a](./alexandria_math/alexandria_math-ed25519-a.md)

    - [c](./alexandria_math/alexandria_math-ed25519-c.md)

    - [d](./alexandria_math/alexandria_math-ed25519-d.md)

    - [d2x](./alexandria_math/alexandria_math-ed25519-d2x.md)

    - [l](./alexandria_math/alexandria_math-ed25519-l.md)

    - [w](./alexandria_math/alexandria_math-ed25519-w.md)

    - [SHA512_LEN](./alexandria_math/alexandria_math-sha512-SHA512_LEN.md)

    - [U64_BIT_NUM](./alexandria_math/alexandria_math-sha512-U64_BIT_NUM.md)

    - [TWO_POW_56](./alexandria_math/alexandria_math-sha512-TWO_POW_56.md)

    - [TWO_POW_48](./alexandria_math/alexandria_math-sha512-TWO_POW_48.md)

    - [TWO_POW_40](./alexandria_math/alexandria_math-sha512-TWO_POW_40.md)

    - [TWO_POW_32](./alexandria_math/alexandria_math-sha512-TWO_POW_32.md)

    - [TWO_POW_24](./alexandria_math/alexandria_math-sha512-TWO_POW_24.md)

    - [TWO_POW_16](./alexandria_math/alexandria_math-sha512-TWO_POW_16.md)

    - [TWO_POW_8](./alexandria_math/alexandria_math-sha512-TWO_POW_8.md)

    - [TWO_POW_4](./alexandria_math/alexandria_math-sha512-TWO_POW_4.md)

    - [TWO_POW_2](./alexandria_math/alexandria_math-sha512-TWO_POW_2.md)

    - [TWO_POW_1](./alexandria_math/alexandria_math-sha512-TWO_POW_1.md)

    - [TWO_POW_0](./alexandria_math/alexandria_math-sha512-TWO_POW_0.md)

    - [MAX_U8](./alexandria_math/alexandria_math-sha512-MAX_U8.md)

    - [MAX_U64](./alexandria_math/alexandria_math-sha512-MAX_U64.md)

  - [Free functions](./alexandria_math/free_functions.md)

    - [pow](./alexandria_math/alexandria_math-pow.md)

    - [aliquot_sum](./alexandria_math/alexandria_math-aliquot_sum-aliquot_sum.md)

    - [is_armstrong_number](./alexandria_math/alexandria_math-armstrong_number-is_armstrong_number.md)

    - [verify](./alexandria_math/alexandria_math-bip340-verify.md)

    - [sequence](./alexandria_math/alexandria_math-collatz_sequence-sequence.md)

    - [pow2_u256](./alexandria_math/alexandria_math-const_pow-pow2_u256.md)

    - [pow2](./alexandria_math/alexandria_math-const_pow-pow2.md)

    - [pow2_felt252](./alexandria_math/alexandria_math-const_pow-pow2_felt252.md)

    - [pow10](./alexandria_math/alexandria_math-const_pow-pow10.md)

    - [pow10_u256](./alexandria_math/alexandria_math-const_pow-pow10_u256.md)

    - [point_mult_double_and_add](./alexandria_math/alexandria_math-ed25519-point_mult_double_and_add.md)

    - [verify_signature](./alexandria_math/alexandria_math-ed25519-verify_signature.md)

    - [extended_euclidean_algorithm](./alexandria_math/alexandria_math-extended_euclidean_algorithm-extended_euclidean_algorithm.md)

    - [fast_power](./alexandria_math/alexandria_math-fast_power-fast_power.md)

    - [fast_power_mod](./alexandria_math/alexandria_math-fast_power-fast_power_mod.md)

    - [fast_nr_optimize](./alexandria_math/alexandria_math-fast_root-fast_nr_optimize.md)

    - [fast_sqrt](./alexandria_math/alexandria_math-fast_root-fast_sqrt.md)

    - [fast_cbrt](./alexandria_math/alexandria_math-fast_root-fast_cbrt.md)

    - [round_div](./alexandria_math/alexandria_math-fast_root-round_div.md)

    - [fib](./alexandria_math/alexandria_math-fibonacci-fib.md)

    - [gcd](./alexandria_math/alexandria_math-gcd_of_n_numbers-gcd.md)

    - [gcd_two_numbers](./alexandria_math/alexandria_math-gcd_of_n_numbers-gcd_two_numbers.md)

    - [i257_div_rem](./alexandria_math/alexandria_math-i257-i257_div_rem.md)

    - [i257_assert_no_negative_zero](./alexandria_math/alexandria_math-i257-i257_assert_no_negative_zero.md)

    - [is_power_of_two](./alexandria_math/alexandria_math-is_power_of_two-is_power_of_two.md)

    - [is_prime](./alexandria_math/alexandria_math-is_prime-is_prime.md)

    - [multiply](./alexandria_math/alexandria_math-karatsuba-multiply.md)

    - [keccak256](./alexandria_math/alexandria_math-keccak256-keccak256.md)

    - [lcm](./alexandria_math/alexandria_math-lcm_of_n_numbers-lcm.md)

    - [add_mod](./alexandria_math/alexandria_math-mod_arithmetics-add_mod.md)

    - [mult_inverse](./alexandria_math/alexandria_math-mod_arithmetics-mult_inverse.md)

    - [add_inverse_mod](./alexandria_math/alexandria_math-mod_arithmetics-add_inverse_mod.md)

    - [sub_mod](./alexandria_math/alexandria_math-mod_arithmetics-sub_mod.md)

    - [mult_mod](./alexandria_math/alexandria_math-mod_arithmetics-mult_mod.md)

    - [u256_wide_sqr](./alexandria_math/alexandria_math-mod_arithmetics-u256_wide_sqr.md)

    - [sqr_mod](./alexandria_math/alexandria_math-mod_arithmetics-sqr_mod.md)

    - [div_mod](./alexandria_math/alexandria_math-mod_arithmetics-div_mod.md)

    - [pow_mod](./alexandria_math/alexandria_math-mod_arithmetics-pow_mod.md)

    - [equality_mod](./alexandria_math/alexandria_math-mod_arithmetics-equality_mod.md)

    - [is_perfect_number](./alexandria_math/alexandria_math-perfect_number-is_perfect_number.md)

    - [perfect_numbers](./alexandria_math/alexandria_math-perfect_number-perfect_numbers.md)

    - [sha256](./alexandria_math/alexandria_math-sha256-sha256.md)

    - [fpow](./alexandria_math/alexandria_math-sha512-fpow.md)

    - [two_pow](./alexandria_math/alexandria_math-sha512-two_pow.md)

    - [sha512](./alexandria_math/alexandria_math-sha512-sha512.md)

    - [fast_sin_inner](./alexandria_math/alexandria_math-trigonometry-fast_sin_inner.md)

    - [fast_sin](./alexandria_math/alexandria_math-trigonometry-fast_sin.md)

    - [fast_cos](./alexandria_math/alexandria_math-trigonometry-fast_cos.md)

    - [fast_tan](./alexandria_math/alexandria_math-trigonometry-fast_tan.md)

    - [u512_add](./alexandria_math/alexandria_math-u512_arithmetics-u512_add.md)

    - [u512_sub](./alexandria_math/alexandria_math-u512_arithmetics-u512_sub.md)

    - [wad](./alexandria_math/alexandria_math-wad_ray_math-wad.md)

    - [ray](./alexandria_math/alexandria_math-wad_ray_math-ray.md)

    - [half_wad](./alexandria_math/alexandria_math-wad_ray_math-half_wad.md)

    - [half_ray](./alexandria_math/alexandria_math-wad_ray_math-half_ray.md)

    - [wad_mul](./alexandria_math/alexandria_math-wad_ray_math-wad_mul.md)

    - [wad_div](./alexandria_math/alexandria_math-wad_ray_math-wad_div.md)

    - [ray_mul](./alexandria_math/alexandria_math-wad_ray_math-ray_mul.md)

    - [ray_div](./alexandria_math/alexandria_math-wad_ray_math-ray_div.md)

    - [ray_to_wad](./alexandria_math/alexandria_math-wad_ray_math-ray_to_wad.md)

    - [wad_to_ray](./alexandria_math/alexandria_math-wad_ray_math-wad_to_ray.md)

    - [day_of_week](./alexandria_math/alexandria_math-zellers_congruence-day_of_week.md)

    - [check_input_parameters](./alexandria_math/alexandria_math-zellers_congruence-check_input_parameters.md)

  - [Structs](./alexandria_math/structs.md)

    - [Point](./alexandria_math/alexandria_math-ed25519-Point.md)

    - [i257](./alexandria_math/alexandria_math-i257-i257.md)

    - [Word64](./alexandria_math/alexandria_math-sha512-Word64.md)

    - [u256X2](./alexandria_math/alexandria_math-u512_arithmetics-u256X2.md)

  - [Enums](./alexandria_math/enums.md)

    - [LCMError](./alexandria_math/alexandria_math-lcm_of_n_numbers-LCMError.md)

  - [Traits](./alexandria_math/traits.md)

    - [BitShift](./alexandria_math/alexandria_math-BitShift.md)

    - [BitmapTrait](./alexandria_math/alexandria_math-bitmap-BitmapTrait.md)

    - [PointOperations](./alexandria_math/alexandria_math-ed25519-PointOperations.md)

    - [I257Trait](./alexandria_math/alexandria_math-i257-I257Trait.md)

    - [WordOperations](./alexandria_math/alexandria_math-sha512-WordOperations.md)

  - [Impls](./alexandria_math/impls.md)

    - [U8BitShift](./alexandria_math/alexandria_math-U8BitShift.md)

    - [U16BitShift](./alexandria_math/alexandria_math-U16BitShift.md)

    - [U32BitShift](./alexandria_math/alexandria_math-U32BitShift.md)

    - [U64BitShift](./alexandria_math/alexandria_math-U64BitShift.md)

    - [U128BitShift](./alexandria_math/alexandria_math-U128BitShift.md)

    - [U256BitShift](./alexandria_math/alexandria_math-U256BitShift.md)

    - [U8BitRotate](./alexandria_math/alexandria_math-U8BitRotate.md)

    - [U16BitRotate](./alexandria_math/alexandria_math-U16BitRotate.md)

    - [U32BitRotate](./alexandria_math/alexandria_math-U32BitRotate.md)

    - [U64BitRotate](./alexandria_math/alexandria_math-U64BitRotate.md)

    - [U128BitRotate](./alexandria_math/alexandria_math-U128BitRotate.md)

    - [U256BitRotate](./alexandria_math/alexandria_math-U256BitRotate.md)

    - [I257Impl](./alexandria_math/alexandria_math-i257-I257Impl.md)

    - [i257Zeroable](./alexandria_math/alexandria_math-i257-i257Zeroable.md)

    - [DisplayI257Impl](./alexandria_math/alexandria_math-i257-DisplayI257Impl.md)

    - [Word64WordOperations](./alexandria_math/alexandria_math-sha512-Word64WordOperations.md)

    - [U512Intou256X2](./alexandria_math/alexandria_math-u512_arithmetics-U512Intou256X2.md)

- [Alexandria Merkle Tree](./alexandria_merkle_tree/alexandria_merkle_tree_info.md)

  - [Modules](./alexandria_merkle_tree/modules.md)

    - [alexandria_merkle_tree](./alexandria_merkle_tree/alexandria_merkle_tree.md)

    - [merkle_tree](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree.md)

    - [storage_proof](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof.md)

    - [pedersen](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-pedersen.md)

    - [poseidon](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-poseidon.md)

  - [Free functions](./alexandria_merkle_tree/free_functions.md)

    - [verify](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-verify.md)

  - [Structs](./alexandria_merkle_tree/structs.md)

    - [Hasher](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-Hasher.md)

    - [MerkleTree](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-MerkleTree.md)

    - [StoredMerkleTree](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-StoredMerkleTree.md)

    - [BinaryNode](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-BinaryNode.md)

    - [EdgeNode](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-EdgeNode.md)

    - [ContractData](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractData.md)

    - [ContractStateProof](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractStateProof.md)

  - [Enums](./alexandria_merkle_tree/enums.md)

    - [TrieNode](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-TrieNode.md)

  - [Traits](./alexandria_merkle_tree/traits.md)

    - [HasherTrait](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-HasherTrait.md)

    - [MerkleTreeTrait](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-MerkleTreeTrait.md)

    - [BinaryNodeTrait](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-BinaryNodeTrait.md)

    - [EdgeNodeTrait](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-EdgeNodeTrait.md)

    - [ContractDataTrait](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractDataTrait.md)

    - [ContractStateProofTrait](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractStateProofTrait.md)

  - [Impls](./alexandria_merkle_tree/impls.md)

    - [PedersenHasherImpl](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-pedersen-PedersenHasherImpl.md)

    - [PoseidonHasherImpl](./alexandria_merkle_tree/alexandria_merkle_tree-merkle_tree-poseidon-PoseidonHasherImpl.md)

    - [BinaryNodeImpl](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-BinaryNodeImpl.md)

    - [EdgeNodeImpl](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-EdgeNodeImpl.md)

    - [ContractDataImpl](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractDataImpl.md)

    - [ContractStateProofImpl](./alexandria_merkle_tree/alexandria_merkle_tree-storage_proof-ContractStateProofImpl.md)

- [Alexandria Numeric](./alexandria_numeric/alexandria_numeric_info.md)

  - [Modules](./alexandria_numeric/modules.md)

    - [alexandria_numeric](./alexandria_numeric/alexandria_numeric.md)

    - [cumprod](./alexandria_numeric/alexandria_numeric-cumprod.md)

    - [cumsum](./alexandria_numeric/alexandria_numeric-cumsum.md)

    - [diff](./alexandria_numeric/alexandria_numeric-diff.md)

    - [integers](./alexandria_numeric/alexandria_numeric-integers.md)

    - [interpolate](./alexandria_numeric/alexandria_numeric-interpolate.md)

    - [trapezoidal_rule](./alexandria_numeric/alexandria_numeric-trapezoidal_rule.md)

  - [Free functions](./alexandria_numeric/free_functions.md)

    - [cumprod](./alexandria_numeric/alexandria_numeric-cumprod-cumprod.md)

    - [cumsum](./alexandria_numeric/alexandria_numeric-cumsum-cumsum.md)

    - [diff](./alexandria_numeric/alexandria_numeric-diff-diff.md)

    - [interpolate](./alexandria_numeric/alexandria_numeric-interpolate-interpolate.md)

    - [interpolate_fast](./alexandria_numeric/alexandria_numeric-interpolate-interpolate_fast.md)

    - [trapezoidal_rule](./alexandria_numeric/alexandria_numeric-trapezoidal_rule-trapezoidal_rule.md)

  - [Enums](./alexandria_numeric/enums.md)

    - [Interpolation](./alexandria_numeric/alexandria_numeric-interpolate-Interpolation.md)

    - [Extrapolation](./alexandria_numeric/alexandria_numeric-interpolate-Extrapolation.md)

  - [Traits](./alexandria_numeric/traits.md)

    - [UIntBytes](./alexandria_numeric/alexandria_numeric-integers-UIntBytes.md)

- [Alexandria Searching](./alexandria_searching/alexandria_searching_info.md)

  - [Modules](./alexandria_searching/modules.md)

    - [alexandria_searching](./alexandria_searching/alexandria_searching.md)

    - [binary_search](./alexandria_searching/alexandria_searching-binary_search.md)

    - [bm_search](./alexandria_searching/alexandria_searching-bm_search.md)

    - [dijkstra](./alexandria_searching/alexandria_searching-dijkstra.md)

    - [levenshtein_distance](./alexandria_searching/alexandria_searching-levenshtein_distance.md)

  - [Free functions](./alexandria_searching/free_functions.md)

    - [binary_search](./alexandria_searching/alexandria_searching-binary_search-binary_search.md)

    - [binary_search_closest](./alexandria_searching/alexandria_searching-binary_search-binary_search_closest.md)

    - [bm_search](./alexandria_searching/alexandria_searching-bm_search-bm_search.md)

    - [dijkstra](./alexandria_searching/alexandria_searching-dijkstra-dijkstra.md)

    - [levenshtein_distance](./alexandria_searching/alexandria_searching-levenshtein_distance-levenshtein_distance.md)

  - [Structs](./alexandria_searching/structs.md)

    - [Node](./alexandria_searching/alexandria_searching-dijkstra-Node.md)

    - [Graph](./alexandria_searching/alexandria_searching-dijkstra-Graph.md)

  - [Traits](./alexandria_searching/traits.md)

    - [GraphTrait](./alexandria_searching/alexandria_searching-dijkstra-GraphTrait.md)

    - [NodeGettersTrait](./alexandria_searching/alexandria_searching-dijkstra-NodeGettersTrait.md)

  - [Impls](./alexandria_searching/impls.md)

    - [NodeGetters](./alexandria_searching/alexandria_searching-dijkstra-NodeGetters.md)

- [Alexandria Sorting](./alexandria_sorting/alexandria_sorting_info.md)

  - [Modules](./alexandria_sorting/modules.md)

    - [alexandria_sorting](./alexandria_sorting/alexandria_sorting.md)

    - [interface](./alexandria_sorting/alexandria_sorting-interface.md)

    - [merge_sort](./alexandria_sorting/alexandria_sorting-merge_sort.md)

    - [quick_sort](./alexandria_sorting/alexandria_sorting-quick_sort.md)

  - [Traits](./alexandria_sorting/traits.md)

    - [interface::Sortable](./alexandria_sorting/alexandria_sorting-interface-Sortable.md)

    - [interface::SortableVec](./alexandria_sorting/alexandria_sorting-interface-SortableVec.md)

  - [Impls](./alexandria_sorting/impls.md)

    - [BubbleSort](./alexandria_sorting/alexandria_sorting-bubble_sort-BubbleSort.md)

    - [merge_sort::MergeSort](./alexandria_sorting/alexandria_sorting-merge_sort-MergeSort.md)

    - [quick_sort::QuickSort](./alexandria_sorting/alexandria_sorting-quick_sort-QuickSort.md)

- [Alexandria Storage](./alexandria_storage/alexandria_storage_info.md)

  - [Modules](./alexandria_storage/modules.md)

    - [alexandria_storage](./alexandria_storage/alexandria_storage.md)

    - [list](./alexandria_storage/alexandria_storage-list.md)

  - [Structs](./alexandria_storage/structs.md)

    - [list::List](./alexandria_storage/alexandria_storage-list-List.md)

  - [Traits](./alexandria_storage/traits.md)

    - [list::ListTrait](./alexandria_storage/alexandria_storage-list-ListTrait.md)

- [Alexandria Utils](./alexandria_utils/alexandria_utils_info.md)

  - [Modules](./alexandria_utils/modules.md)

    - [alexandria_utils](./alexandria_utils/alexandria_utils.md)

    - [fmt](./alexandria_utils/alexandria_utils-fmt.md)

  - [Impl aliases](./alexandria_utils/impl_aliases.md)

    - [EthAddressDisplay](./alexandria_utils/alexandria_utils-fmt-EthAddressDisplay.md)

    - [ContractAddressDisplay](./alexandria_utils/alexandria_utils-fmt-ContractAddressDisplay.md)

    - [ClassHashDisplay](./alexandria_utils/alexandria_utils-fmt-ClassHashDisplay.md)

    - [StorageAddressDisplay](./alexandria_utils/alexandria_utils-fmt-StorageAddressDisplay.md)

    - [EthAddressDebug](./alexandria_utils/alexandria_utils-fmt-EthAddressDebug.md)

    - [ContractAddressDebug](./alexandria_utils/alexandria_utils-fmt-ContractAddressDebug.md)

    - [ClassHashDebug](./alexandria_utils/alexandria_utils-fmt-ClassHashDebug.md)

    - [StorageAddressDebug](./alexandria_utils/alexandria_utils-fmt-StorageAddressDebug.md)

  - [Impls](./alexandria_utils/impls.md)

    - [SpanTDebug](./alexandria_utils/alexandria_utils-fmt-SpanTDebug.md)
