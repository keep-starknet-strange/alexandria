/// Usage: pow_inline!(base, exponent)
pub macro pow_inline {
    ($base:expr, $exp:expr) => {
        alexandria_math::pow($base, $exp)
    };
}
