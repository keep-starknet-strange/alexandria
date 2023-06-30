# Numerical analysis

## [Trapezoidal rule](./src/trapz.cairo)

In numerical analysis and scientific computing, the trapezoidal rule is a numerical method to solve ordinary differential equations derived from the trapezoidal rule for computing integrals ([see also](https://en.wikipedia.org/wiki/Trapezoidal_rule_(differential_equations))).

## [Interpolation](./src/interp.cairo)

Returns the one-dimensional piecewise linear interpolant to a function with given discrete data points (xs, ys), evaluated at x ([see also](https://numpy.org/doc/stable/reference/generated/numpy.interp.html)).
Several interpolation methods are supported as follow:
- Linear interpolation: y is linearly interpolated between the two nearest neighbors at x
- Nearest-neighbor interpolation: y is set to the value of the nearest neighbor at x
- Constant left interpolation: ys behaves as a integer part function where each y data point extends to the left up to the next index
- Constant right interpolation: ys behaves as a integer part function where each y data point extends to the right up to the next index

## [Cumsum](./src/cumsum.cairo)

Return the cumulative sum of the elements ([see also](https://numpy.org/doc/stable/reference/generated/numpy.cumsum.html#numpy-cumsum)).

## [Diff](./src/diff.cairo)

Return the discrete difference of the elements ([see also](https://numpy.org/doc/stable/reference/generated/numpy.diff.html#numpy.diff)).