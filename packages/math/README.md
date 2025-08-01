# Math

## [Fixed-Point Decimal](./src/decimal.cairo)

The decimal implementation provides a 64/64 bit fixed-point number system designed for precise decimal arithmetic without floating-point precision issues. Unlike IEEE 754 floating-point formats, this uses pure fixed-point arithmetic with separate 64-bit fields for the integer and fractional parts, providing approximately 19 decimal places of precision with consistent accuracy across all values.

### Key Features:

- **User-friendly construction**: Create decimals using `from_parts(3, 35)` for 3.35 or `from_parts(56, 678)` for 56.678
- **Overflow-safe arithmetic**: All operations (add, sub, mul, div) use u256 intermediate calculations to prevent overflow
- **Operator overloads**: Supports `+`, `-`, `*`, `/` operators for natural mathematical expressions
- **String conversion**: Complete string representation and parsing capabilities with 6-digit precision format
- **JSON integration**: Seamless serialization and deserialization with the parser package

### String Format:

All decimal values are formatted with **6 decimal places** (microsecond precision) when converted to strings:
- `DecimalTrait::from_int(25)` → `"25.000000"`
- `DecimalTrait::from_parts(99, 5)` → `"99.500000"` (99.5)
- `DecimalTrait::from_parts(5, 25)` → `"5.250000"` (5.25)
- `DecimalTrait::from_int(0)` → `"0.000000"`

This consistent 6-digit format ensures predictable string representations for JSON serialization, database storage, and display purposes, providing microsecond-level precision suitable for financial calculations and scientific applications.

The decimal system supports all basic arithmetic operations with proper overflow protection and integrates with other Alexandria packages for comprehensive mathematical operations.

## [Fast Root](./src/fast_root.cairo)

The fast root algorithm uses Newton-Raphson method to calculate a arbitrary root of a given number (e.g., square root, cubic root, etc.). The algorithm is used to find the roots of a polynomial equation, which has applications in various areas of mathematics, including algebra, calculus, and number theory. The fast root algorithm is also used in computer science, as it can be used to solve problems involving the roots of a polynomial equation.

## [Is Power Of Two](./src/is_power_of_two.cairo)

The `is_power_of_two` algorithm is used to determine whether a given positive integer is a power of two or not.

## [Fast trigonometric functions (sin, cos, tan)](./src/trigonometry.cairo)

The trigonometric functions are a set of mathematical functions that relate the angles of a triangle to the lengths of its sides. The most common trigonometric functions are sine, cosine, and tangent. These functions are used in many areas of mathematics, including geometry, calculus, and statistics. They are also used in physics, engineering, and other sciences.

Fast trigonometric functions are computational and spatial efficient, with minor errors compared to the standard trigonometric functions. Refer to http://hevi.info/tag/fast-sine-function/ for detailed information.

## [Is Prime](./src/is_prime.cairo)

The `is_prime` algorithm is used to determine whether a given positive integer is a prime number or not.

## [Aliquot sum](./src/aliquot_sum.cairo)

The aliquot sum algorithm calculates the sum of proper divisors of a given positive integer, providing insight into factors and divisors of a number, and classifying it as perfect, abundant, or deficient.
These classifications have applications in areas of math, including geometry, cryptography, and number theory. The algorithm is used for problem-solving and generating puzzles and games.

## [Armstrong number](./src/armstrong_number.cairo)

The Armstrong number algorithm is used to determine if a number is an Armstrong number, where the sum of its digits raised to the power of the number of digits equals the original number.
The algorithm is used for problem-solving and mathematical puzzles, and has applications in number theory, discrete mathematics, and computer science, as well as in generating strong encryption keys.
By identifying Armstrong numbers, the algorithm provides insight into the properties of numbers and can be used in various applications in mathematics and computer science.

## [Bitmap](./src/bitmap.cairo)

Bitmap function to manage, search and manipulate bits efficiently.

## [Collatz sequence](./src/collatz_sequence.cairo)

The Collatz sequence number algorithm is a mathematical algorithm used to generate the Collatz sequence of a given positive integer.
The purpose of the Collatz sequence number algorithm is to explore the behavior of the Collatz conjecture, which is a famous unsolved problem in mathematics. The conjecture states that for any positive integer, the Collatz sequence will eventually reach the number 1. The Collatz sequence number algorithm is used to generate and study these sequences, which have applications in various areas of mathematics and computer science.
Additionally, the algorithm is used in generating mathematical puzzles and in teaching concepts such as iteration, recursion, and complexity theory.

## [Extended euclidean](./src/extended_euclidean_algorithm.cairo)

The extended Euclidean algorithm is a mathematical algorithm used to calculate the greatest common divisor (GCD) of two numbers and to find the coefficients that satisfy the Bézout's identity, which is a relationship between the GCD and the two numbers.
The purpose of the extended Euclidean algorithm is to provide a way to solve linear Diophantine equations, which are equations in which the variables must be integers.
The algorithm has applications in various areas of mathematics, including number theory, cryptography, and computer science. Additionally, the algorithm is used in generating encryption keys and in solving problems related to modular arithmetic.

## [Fast power](./src/fast_power.cairo)

The fast power algorithm is a mathematical algorithm used to efficiently calculate the power of a given number.
The purpose of the fast power algorithm is to reduce the number of operations required to calculate a power, making it more efficient than traditional methods. The algorithm has applications in various areas of mathematics and computer science, including cryptography, where it is used to perform exponentiation in encryption and decryption operations. The fast power algorithm is also used in programming and software development, as it can improve the efficiency of algorithms that require the calculation of powers.
By reducing the number of operations required to calculate a power, the fast power algorithm provides a more efficient way to perform calculations involving powers.

## [Fibonacci](./src/fibonacci.cairo)

The Fibonacci algorithm is a mathematical algorithm used to generate the Fibonacci sequence, which is a sequence of numbers where each number is the sum of the previous two.
The purpose of the Fibonacci algorithm is to explore the properties and patterns of the Fibonacci sequence, which has applications in various areas of mathematics, including number theory, combinatorics, and geometry. The algorithm is also used in problem-solving and generating mathematical puzzles and games. Additionally, the Fibonacci sequence has applications in computer science and data structures, as it can be used to model recursive algorithms and to generate random numbers.

## [GCD of N numbers](./src/gcd_of_n_numbers.cairo)

The GCD (Greatest Common Divisor) of n numbers algorithm is used to find the largest positive integer that divides each of the given n numbers without a remainder.
The purpose of this algorithm is to determine the highest common factor of the given set of numbers. It has applications in various areas of mathematics, including number theory, algebra, and cryptography. The GCD of n numbers algorithm is used in many real-world applications, such as finding the optimal solution to a problem that requires dividing resources among multiple agents. It is also used in computer science for designing efficient algorithms that require determining common factors or multiples of numbers.

## [LCM of N numbers](./src/lcm_of_n_numbers.cairo)

The LCM (Lowest Common Multiple) of n numbers algorithm is used to find the smallest positive integer that is a multiple of each of the given n numbers ([see also](https://numpy.org/doc/stable/reference/generated/numpy.lcm.html)).

## [Perfect Number Algorithm](./src/perfect_number.cairo)

The perfect number algorithm is used to determine whether a given positive integer is a perfect number or not.
A perfect number is a positive integer that is equal to the sum of its proper divisors (excluding itself).
The purpose of the algorithm is to identify these special numbers and to study their properties. Perfect numbers have applications in various areas of mathematics, including number theory and algebraic geometry. They are also used in cryptography and coding theory. The perfect number algorithm is important for understanding the structure of numbers and their relationships to each other, and it has been studied for centuries by mathematicians.

## [Schnorr Signature Verification - BIP340](./src/schnorr.cairo)
Schnorr Signature Verification has been implemented according to [BIP-340](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki). Secp256k1 elliptic curve has been utilized, and Schnorr signature offers provable security, non-malleability (unlike ECDSA), and linearity which makes it efficient to aggregate signatures from multiple public keys.

## [Zeller's congruence](./src/zellers_congruence.cairo)

Zeller's congruence algorithm is used to determine the day of the week for a given date.
The purpose of the algorithm is to provide a simple and efficient way to calculate the day of the week based on the date.
It is widely used in various applications, including calendar systems, scheduling, and time management.
The algorithm takes into account the year, month, and day of the given date and performs a series of mathematical calculations to determine the day of the week. By providing an easy-to-use method for calculating the day of the week, Zeller's congruence algorithm is an important tool for many industries and organizations that rely on accurate and efficient time management systems.

## [ed25519](./src/ed25519.cairo)

In public-key cryptography, Edwards-curve Digital Signature Algorithm (EdDSA) is a digital signature scheme using a variant of Schnorr signature based on twisted Edwards curves. It is designed to be faster than existing digital signature schemes without sacrificing security.

## [sha512](./src/sha512.cairo)

SHA-512 is from the SHA-2 family (Secure Hash Algorithm 2) which is a set of cryptographic hash functions designed by the United States National Security Agency (NSA) and first published in 2001. They are built using the Merkle–Damgård construction, from a one-way compression function itself built using the Davies–Meyer structure from a specialized block cipher.

## [ripemd160](./src/ripemd160.cairo)

RIPEMD-160 (RACE Integrity Primitives Evaluation Message Digest) is a cryptographic hash function that produces a 160-bit (20-byte) hash digest. It was developed in Europe as an alternative to the US-designed SHA-1 algorithm and is part of the RIPEMD family of hash functions. RIPEMD-160 was designed to provide strong collision resistance and is built using a dual-line parallel structure with 5 rounds on each side, processing data in 512-bit blocks. The algorithm employs the Merkle-Damgård construction and uses 5 different round functions (f, g, h, i, j) applied in different orders on the left and right processing lines.

This implementation is based on the original Cairo work by [j1mbo64](https://github.com/j1mbo64/ripemd160_cairo), enhanced with some performance optimizations. The implementation provides multiple output formats (u256, ByteArray, Array<u32>) and is suitable for digital signatures, data integrity verification, and cryptographic applications requiring 160-bit hash digests.
