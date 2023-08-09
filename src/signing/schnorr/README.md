# Schnorr Signature:

In the context of blockchain, we can say things like this: we want to make a transaction but multiple people must authorize it, this is defined as a "multisig" setup. Somehow, we can use the public keys of those who need to authorize the transaction to create another key, an aggregated public key, which will be a new transaction key, and this is possible with the Schnorr method.

## Alright, how can we implement it?

Let's understand that we'll be working with Elliptic Curve Cryptography (ECC).

•	We start with a generator (G), a public and standardized value. It is a point on the curve.
•	We choose a private key (let's call it "ska"), which is a large number.
•	And with these values, we can find the public key, which will result from multiplying G * ska.

Operations on elliptic curves are very curious, doing the multiplication referred to above does not obey conventional multiplication. Super interesting geometric and algebraic issues are involved.

For the purposes of this content, we can say that after finding the public key (which we'll call Pa), we can publish that result without issues because attempting to find the value of ska (the private key) starting from Pa is considered "infeasible" in computational terms.

## A brief summary:

•	G: The generator (it is a point on the curve).
•	ska: Private key.
•	Pa: Public key (G * ska, they are also coordinates on the curve).

## What is happening?

We can use this system to obtain more public keys starting from the private ones. Taking skb as the private key:

We can calculate Pb = G * skb obtaining another public key.

## And what will we do with this?

As mentioned previously, we can take these public keys and perform a procedure to obtain an aggregated public key. This aggregated public key will function as a new transaction key, allowing a group of signers, each with their own private/public key pair, to collaborate and generate a single signature for a message using multi-signature protocols.

One simple approach to create a multi-signature scheme from a standard signature scheme is to have each signer create a unique signature for the message using their private key and then concatenate all of the individual signatures. If that is the case, the size of the multi-signature will increase linearly with the number of signers. For that reason, this approach can be inefficient. A multi-signature scheme that generates signatures that are not influenced by the number of signers would be interesting.

For that reason, we are talking about Schnorr signatures, but when working with this system, there is a risk of key cancellation attacks. How can we avoid it? In the following way:

There is a paper written by Maxwell, Poelstra, Seurin, and Wuille which describes a multi-signature scheme based on Schnorr, called MuSig. You can consult that paper [here](https://eprint.iacr.org/2018/068.pdf).

The MuSig scheme helps us prevent the key cancellation attack. Let's see a scheme of how it works:

![Graph](https://github.com/cliraa/alexandria/blob/main/src/signing/images/musig_scheme.jpg)

Here you can find an implementation of this in Cairo: [link](https://github.com/cliraa/alexandria/blob/main/src/signing/musig_scheme_secp256k1.cairo)
