# Macros

A collection of useful macros.

- [Macros](#macros)
  - [Add, Sub, Mul, Div derives](#add-sub-mul-div-derives)
  - [AddAssign, SubAssign, MulAssign, DivAssign derives](#addassign-subassign-mulassign-divassign-derives)
  - [pow!](#pow)
  - [Zero derive](#zero-derive)
  - [generate\_events](#generate_events)
    - [Usage](#usage)
    - [What it generates](#what-it-generates)

## Add, Sub, Mul, Div derives

These macros add the ability to use addition `+`, subtraction `-`, multiplication `*` and division `/` operators on the type that derives them. All individual members of the struct must already support a particular operation for a derive to work.

```rust
#[derive(Add, Sub, Mul, Div)]
struct Point {
    x: u32,
    y: u32
}

let a = Point { x: 6, y: 32 };
let b = Point { x: 2, y: 2 };
let c = a + b; // Point { x: 8, y: 34 }
let d = a - b; // Point { x: 4, y: 30 }
let e = a * b; // Point { x: 12, y: 64 }
let f = a / b; // Point { x: 3, y: 16 }
```

## AddAssign, SubAssign, MulAssign, DivAssign derives

These macros add the ability to use add and assign `+=`, subtract and assign `-=`, multiply and assign `*=` and divide and assign `/=` operators on the type that derives them. All individual members of the struct must already support the particular operation for a derive to work.

```rust
#[derive(AddAssign, SubAssign, MulAssign, DivAssign)]
struct Point {
    x: u32,
    y: u32
}

let mut a = Point { x: 6, y: 32 };
let b = Point { x: 2, y: 2 };
a += b; // Point { x: 8, y: 34 }
a -= b; // Point { x: 6, y: 32 }
a *= b; // Point { x: 12, y: 64 }
a /= b; // Point { x: 6, y: 32 };
```

## pow!

Power function. Takes two arguments, `x, y`, calculates the value of `x` raised to the power of `y`.

```cairo
const MEGABYTE: u64 = pow!(2, 20); // will be set to 1048576
```

## Zero derive

Adds implementation of the `core::num::traits::Zero` trait.

All members of the struct must already implement the `Zero` trait.

```rust
#[derive(Zero, PartialEq, Debug)]
struct Point {
    x: u64,
    y: u64,
}
assert_eq!(Point { x: 0, y: 0 }, Zero::zero());
assert!(Point { x: 0, y: 0 }.is_zero());
assert!(Point { x: 1, y: 0 }.is_non_zero());
```

## generate_events

Automatically generates event structs for Starknet contracts. This macro simplifies event management by creating the necessary struct definitions based on an enum declaration.

### Usage

```rust
use alexandria_macros::generate_events;

#[starknet::contract]
mod MyContract {
    use starknet::event::EventEmitter;

    #[generate_events]
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Transfer: Transfer,
        Approval: Approval,
        Mint: Mint,
    }

    #[storage]
    struct Storage {
        // ... your storage fields
    }

    #[abi(embed_v0)]
    impl MyContract of IMyContract<ContractState> {
        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            // ... transfer logic
            
            // Emit the event
            self.emit(Transfer { data: array![to.into(), amount.into()].span() }
            ));
        }
    }
}
```

### What it generates

The `generate_events` macro automatically creates event structs with a standardized `data` field:

```rust
// Generated automatically by the macro
#[derive(Drop, starknet::Event)]
pub struct Transfer {
    pub data: Span<felt252>,
}

#[derive(Drop, starknet::Event)]
pub struct Approval {
    pub data: Span<felt252>,
}

#[derive(Drop, starknet::Event)]
pub struct Mint {
    pub data: Span<felt252>,
}
```
