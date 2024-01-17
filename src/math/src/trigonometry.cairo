// Calculate fast sin(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate sin(x)
// # Returns
// * `bool` - true if the result is positive, false if the result is negative
// * `u64` - sin(x) * 1e8
// # Example
// * fast_sin(3000000000) = (true, 50000000)
fn fast_sin(x: u64) -> (bool, u64) {
    let multipier = 100000000_u64;
    let hollyst: u64 = 1745329_u64;
    let sin_table = array![
        0_u64,           // sin(0)
        17364818_u64,    // sin(10)
        34202014_u64,    // sin(20)
        50000000_u64,    // sin(30)
        64278761_u64,    // sin(40)
        76604444_u64,    // sin(50)
        86602540_u64,    // sin(60)
        93969262_u64,    // sin(70)
        98480775_u64,    // sin(80)
        100000000_u64    // sin(90)
    ];
    let cos_table = array![
        100000000_u64,   // cos(0)
        99984769_u64,    // cos(1)
        99939082_u64,    // cos(2)
        99862953_u64,    // cos(3)
        99756405_u64,    // cos(4)
        99619470_u64,    // cos(5)
        99452190_u64,    // cos(6)
        99254615_u64,    // cos(7)
        99026807_u64,    // cos(8)
        98768834_u64,    // cos(9)
    ];
    
    let mut a = x % (360_u64 * multipier);
    let mut sig = true;
    if a > (180_u64 * multipier) {
        sig = false;
        a = a - (180_u64 * multipier);
    }

    if a > (90_u64 * multipier) {
        a = (180_u64 * multipier) - a;
    }

    let i: usize = (a / (10_u64 * multipier)).try_into().unwrap();
    let j = a - i.into() * (10_u64 * multipier);
    let int_j: usize = (j / multipier).try_into().unwrap();

    let y = *sin_table[i] * *cos_table[int_j] / multipier + ((j * hollyst) / multipier) * *sin_table[9 - i] / multipier;
    
    return (sig, y);
}

// Calculate fast cos(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate cos(x)
// # Returns
// * `bool` - true if the result is positive, false if the result is negative
// * `u64` - cos(x) * 1e8
// # Example
// * fast_cos(6000000000) = (true, 50000000)
fn fast_cos(x: u64) -> (bool, u64) {
    let multipier = 100000000_u64;
    return fast_sin(x + 90_u64 * multipier);
}

// Calculate fast tan(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate tan(x)
// # Returns
// * `bool` - true if the result is positive, false if the result is negative
// * `u64` - tan(x) * 1e8
// # Example
// * fast_tan(4500000000) = (true, 100000000)
fn fast_tan(x: u64) -> (bool, u64) {
    let multipier = 100000000_u64;
    let (sig_sin, sin) = fast_sin(x);
    let (sig_cos, cos) = fast_cos(x);
    let sig = sig_sin || sig_cos;
    let value = sin * multipier / cos;
    return (sig, value);
}