# RLPItem

Fully qualified path: `alexandria_encoding::rlp::RLPItem`

```rust
#[derive(Drop, Copy, PartialEq)]
pub enum RLPItem {
    String: Span<u8>,
    List: Span<RLPItem>,
}
```

## Variants

### String

Fully qualified path: `alexandria_encoding::rlp::RLPItem::String`

```rust
String : Span < u8 >
```

### List

Fully qualified path: `alexandria_encoding::rlp::RLPItem::List`

```rust
List : Span < RLPItem >
```

