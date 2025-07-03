# stack

Stack implementation.  # Example
```cairo
use alexandria::data_structures::stack::StackTrait;

// Create a new stack instance.
let mut stack = StackTrait::new();
// Create an item and push it to the stack.
let mut item:u256 = 1.into();
stack.push(item);
Remove the item from the stack;
let item = stack.pop();
```

Fully qualified path: `alexandria_data_structures::stack`

## Structs

- [Felt252Stack](./alexandria_data_structures-stack-Felt252Stack.md)

- [NullableStack](./alexandria_data_structures-stack-NullableStack.md)

## Traits

- [StackTrait](./alexandria_data_structures-stack-StackTrait.md)

