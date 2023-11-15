/// Provides functions to perform calculations with Wad and Ray units
/// @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
/// with 27 digits of precision)
/// Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
/// https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/math/WadRayMath.sol

const WAD: u256 = 1_000_000_000_000_000_000; // 1e18
const HALF_WAD: u256 = 500_000_000_000_000_000; // 0.5e18
const RAY: u256 = 1_000_000_000_000_000_000_000_000_000; // 1e27
const HALF_RAY: u256 = 500_000_000_000_000_000_000_000_000; // 0.5e27
const WAD_RAY_RATIO: u256 = 1_000_000_000; // 1e9
const HALF_WAD_RAY_RATIO: u256 = 500_000_000; // 0.5e9


/// Return the wad value
/// # Returns
/// * `u256` - The value
fn wad() -> u256 {
    return WAD;
}

/// Return the ray value
/// # Returns
/// * `u256` - The value
fn ray() -> u256 {
    return RAY;
}

/// Return the half wad value
/// # Returns
/// * `u256` - The value
fn half_wad() -> u256 {
    return HALF_WAD;
}

/// Return the half ray value
/// # Returns
/// * `u256` - The value
fn half_ray() -> u256 {
    return HALF_RAY;
}


/// Multiplies two wad, rounding half up to the nearest wad
/// # Arguments
/// * a Wad
/// * b Wad
/// # Returns
/// * a*b, in wad
fn wad_mul(a: u256, b: u256) -> u256 {
    return (a * b + HALF_WAD) / WAD;
}

/// Divides two wad, rounding half up to the nearest wad
/// # Arguments
/// * a Wad
/// * b Wad
/// # Returns
/// * a/b, in wad
fn wad_div(a: u256, b: u256) -> u256 {
    return (a * WAD + (b / 2)) / b;
}

/// Multiplies two ray, rounding half up to the nearest ray
/// # Arguments
/// * a Ray
/// * b Ray
/// # Returns
/// * a raymul b
fn ray_mul(a: u256, b: u256) -> u256 {
    return (a * b + HALF_RAY) / RAY;
}

/// Divides two ray, rounding half up to the nearest ray
/// # Arguments
/// * a Ray
/// * b Ray
/// # Returns
/// * a raydiv b
fn ray_div(a: u256, b: u256) -> u256 {
    return (a * RAY + (b / 2)) / b;
}

/// Casts ray down to wad
/// # Arguments
/// * a Ray
/// # Returns
/// * a converted to wad, rounded half up to the nearest wad
fn ray_to_wad(a: u256) -> u256 {
    return (HALF_WAD_RAY_RATIO + a) / WAD_RAY_RATIO;
}

/// Converts wad up to ray
/// # Arguments
/// * a Wad
/// # Returns
/// * a converted to ray
fn wad_to_ray(a: u256) -> u256 {
    return a * WAD_RAY_RATIO;
}

