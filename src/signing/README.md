# Digital signatures:

## The basics:

Let's suppose that a person, whom we will call Alice, wants to send a message to another person, whom we will call Bob, but Alice wants to prove that she was the one who sent it. To do that, Alice can use a private key to create a digital signature, and Bob will be able to verify that signature.

A digital signature provides the recipient with the following information:

- The message was created by a known sender (authentication).

- The message was not altered in transit (integrity).

For that reason, when we do this process, we are considering two parties:

- The signer.

- And the verifier.

It is then said that a digital signature is a mathematical scheme for verifying the authenticity of digital messages.

Some digital signature algorithms are:

- ECDSA (Elliptic Curve Digital Signature Algorithm).

- [Schnorr signature](./src/signing/schnorr/README.md)
