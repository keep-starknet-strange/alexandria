use alexandria_data_structures::array_ext::ArrayTraitExt;
use core::num::traits::Zero;

pub trait ToAsciiTrait<T, U> {
    fn to_ascii(self: T) -> U;
}

// converts integers into an array of its individual ascii values
pub trait ToAsciiArrayTrait<T> {
    fn to_ascii_array(self: T) -> Array<felt252>;
    fn to_inverse_ascii_array(self: T) -> Array<felt252>;
}

// converts integers into an array of its individual ascii values
// e.g. 123 -> [49, 50, 51]
impl ToAsciiArrayTraitImpl<
    T,
    +PartialOrd<T>,
    +DivRem<T>,
    +Into<T, felt252>,
    +TryInto<felt252, T>,
    +TryInto<T, NonZero<T>>,
    +Zero<T>,
    +Drop<T>,
    +Copy<T>,
> of ToAsciiArrayTrait<T> {
    fn to_ascii_array(self: T) -> Array<felt252> {
        let mut new_arr = self.to_inverse_ascii_array();
        new_arr.reversed()
    }

    fn to_inverse_ascii_array(self: T) -> Array<felt252> {
        let mut new_arr = array![];
        if self <= 9.try_into().unwrap() {
            new_arr.append(self.into() + 48);
            return new_arr;
        }

        let mut num = self;
        while num.is_non_zero() {
            let (quotient, remainder) = DivRem::div_rem(
                num,
                TryInto::<felt252, T>::try_into(10).unwrap().try_into().expect('Division by 0'),
            );
            new_arr.append(remainder.into() + 48);
            num = quotient;
        }
        new_arr
    }
}

// generic implementation for small integers <u128
// to transform its integers into a string represented as a single felt252
// e.g. 1000 -> "1000"
impl SmallIntegerToAsciiTraitImpl<
    T,
    +PartialOrd<T>,
    +DivRem<T>,
    +Into<T, felt252>,
    +TryInto<felt252, T>,
    +TryInto<T, NonZero<T>>,
    +Zero<T>,
    +Drop<T>,
    +Copy<T>,
> of ToAsciiTrait<T, felt252> {
    fn to_ascii(self: T) -> felt252 {
        if self <= 9.try_into().unwrap() {
            return self.into() + 48;
        }

        let mut inverse_ascii_arr = self.to_inverse_ascii_array().span();
        let mut ascii: felt252 = 0;
        loop {
            match inverse_ascii_arr.pop_back() {
                Option::Some(val) => { ascii = ascii * 256 + *val; },
                Option::None(_) => { break; },
            };
        }

        ascii
    }
}

// generic implementation for big integers u128
// to transform its integers into a string represented as multiple felt252 if there is overflow
// e.g. max_num + 123 -> ["max_num", "123"]
impl BigIntegerToAsciiTraitImpl<
    T,
    +PartialOrd<T>,
    +DivRem<T>,
    +Into<T, felt252>,
    +TryInto<felt252, T>,
    +TryInto<T, NonZero<T>>,
    +Zero<T>,
    +Drop<T>,
    +Copy<T>,
> of ToAsciiTrait<T, Array<felt252>> {
    fn to_ascii(self: T) -> Array<felt252> {
        let mut data = array![];
        if self <= 9.try_into().unwrap() {
            data.append(self.into() + 48);
            return data;
        }

        let mut inverse_ascii_arr = self.to_inverse_ascii_array().span();
        let mut ascii: felt252 = 0;
        let mut index = 0;
        loop {
            match inverse_ascii_arr.pop_back() {
                Option::Some(val) => {
                    let new_ascii = ascii * 256 + *val;
                    // if index is at 30 it means we have reached the max size of felt252 at 31
                    // characters so we append the current ascii and reset the ascii to 0
                    ascii = if index == 30 {
                        data.append(new_ascii);
                        0
                    } else {
                        new_ascii
                    };
                },
                Option::None(_) => {
                    // if ascii is 0 it means we have already appended the first ascii
                    // and there's no need to append it again
                    if ascii.is_non_zero() {
                        data.append(ascii);
                    }
                    break;
                },
            }
            index += 1;
        }
        data
    }
}

// -------------------------------------------------------------------------- //
//                                  for u256                                  //
// -------------------------------------------------------------------------- //
// have to implement separately for u256 because
// it doesn't have the same implementations as the generic version
impl U256ToAsciiArrayTraitImpl of ToAsciiArrayTrait<u256> {
    fn to_ascii_array(self: u256) -> Array<felt252> {
        let mut new_arr = self.to_inverse_ascii_array();
        new_arr.reversed();
        new_arr
    }

    fn to_inverse_ascii_array(self: u256) -> Array<felt252> {
        let mut new_arr = array![];
        if self <= 9 {
            new_arr.append(self.try_into().expect('number overflow felt252') + 48);
            return new_arr;
        }
        let mut num = self;
        while num != 0 {
            let (quotient, remainder) = DivRem::div_rem(
                num, 10_u256.try_into().expect('Division by 0'),
            );
            new_arr.append(remainder.try_into().expect('number overflow felt252') + 48);
            num = quotient;
        }
        new_arr
    }
}

impl U256ToAsciiTraitImpl of ToAsciiTrait<u256, Array<felt252>> {
    fn to_ascii(self: u256) -> Array<felt252> {
        let mut data = array![];
        if self <= 9 {
            data.append(self.try_into().expect('number overflow felt252') + 48);
            return data;
        }

        let mut inverse_ascii_arr = self.to_inverse_ascii_array().span();
        let mut index = 0;
        let mut ascii: felt252 = 0;
        while let Option::Some(val) = inverse_ascii_arr.pop_back() {
            let new_ascii = ascii * 256 + *val;
            // if index is currently at 30 it means we have processed the number for index 31
            // this means we have reached the max size of felt252 at 31 characters
            // so we append the current ascii and reset the ascii to 0
            // do the same at index 61 as well because max u256 is 78 characters
            ascii = if index == 30 || index == 61 {
                data.append(new_ascii);
                0
            } else {
                new_ascii
            };
            index += 1;
        }

        if ascii.is_non_zero() {
            data.append(ascii);
        }
        data
    }
}
