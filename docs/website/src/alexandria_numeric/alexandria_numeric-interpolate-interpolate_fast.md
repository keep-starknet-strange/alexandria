# interpolate_fast

Fast interpolation function that uses binary search for efficient value lookup. Optimized version of interpolate() with O(log n) time complexity instead of O(n).

Time complexity: O(log n) due to binary search Space complexity: O(1)

## Arguments

- `x` - The position at which to interpolate
- `xs` - The sorted abscissa sequence of length L (must be monotonically increasing)
- `ys` - The ordinate sequence of length L corresponding to xs values
- `interpolation` - The interpolation method to use (Linear, Nearest, ConstantLeft, ConstantRight)
- `extrapolation` - The extrapolation method for values outside xs range (Null, Constant)

## Returns

- `T` - The interpolated/extrapolated value y at position x

## Requirements

- xs and ys must have the same length
- xs must be sorted in ascending order
- Both arrays must have at least 2 elements
- Type T must implement required arithmetic and comparison traits

## Panics

- If xs and ys have different lengths
- If arrays have fewer than 2 elements
- If xs is not properly sorted
- If binary search fails to find appropriate index

Fully qualified path: `alexandria_numeric::interpolate::interpolate_fast`

```rust
pub fn interpolate_fast<
    T, +PartialOrd<T>, +Add<T>, +Sub<T>, +Mul<T>, +Div<T>, +Zero<T>, +Copy<T>, +Drop<T>,
>(
    x: T, xs: Span<T>, ys: Span<T>, interpolation: Interpolation, extrapolation: Extrapolation,
) -> T
```
