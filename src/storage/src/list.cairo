use integer::U32DivRem;
use poseidon::poseidon_hash_span;
use starknet::storage_access::{
    Store, StorageBaseAddress, storage_address_to_felt252, storage_address_from_base,
    storage_base_address_from_felt252
};
use starknet::{storage_read_syscall, storage_write_syscall, SyscallResult, SyscallResultTrait};

const POW2_8: u32 = 256; // 2^8

#[derive(Drop)]
struct List<T> {
    address_domain: u32,
    base: StorageBaseAddress,
    len: u32, // number of elements in array
    storage_size: u8
}

trait ListTrait<T> {
    /// Instantiates a new List with the given base address.
    ///
    ///
    /// # Arguments
    ///
    /// * `address_domain` - The domain of the address. Only address_domain 0 is
    /// currently supported, in the future it will enable access to address
    /// spaces with different data availability
    /// * `base` - The base address of the List. This corresponds to the
    /// location in storage of the List's first element.
    ///
    /// # Returns
    ///
    /// A new List.
    fn new(address_domain: u32, base: StorageBaseAddress) -> List<T>;

    /// Fetches an existing List stored at the given base address.
    /// Returns an error if the storage read fails.
    ///
    /// # Arguments
    ///
    /// * `address_domain` - The domain of the address. Only address_domain 0 is
    /// currently supported, in the future it will enable access to address
    /// spaces with different data availability
    /// * `base` - The base address of the List. This corresponds to the
    /// location in storage of the List's first element.
    ///
    /// # Returns
    ///
    /// An instance of the List fetched from storage, or an error in
    /// `SyscallResult`.
    fn fetch(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<List<T>>;

    /// Appends an existing Span to a List. Returns an error if the span
    /// cannot be appended to the a list due to storage errors
    ///
    /// # Arguments
    ///
    /// * `self` - The List to add the span to.
    /// * `span` - A Span to append to the List.
    ///
    /// # Returns
    ///
    /// A List constructed from the span or an error in `SyscallResult`.
    fn append_span(ref self: List<T>, span: Span<T>) -> SyscallResult<()>;

    /// Gets the length of the List.
    ///
    /// # Returns
    ///
    /// The number of elements in the List.
    fn len(self: @List<T>) -> u32;

    /// Checks if the List is empty.
    ///
    /// # Returns
    ///
    /// `true` if the List is empty, `false` otherwise.
    fn is_empty(self: @List<T>) -> bool;

    /// Appends a value to the end of the List. Returns an error if the append
    /// operation fails due to reasons such as storage issues.
    ///
    /// # Arguments
    ///
    /// * `value` - The value to append.
    ///
    /// # Returns
    ///
    /// The index at which the value was appended or an error in `SyscallResult`.
    fn append(ref self: List<T>, value: T) -> SyscallResult<u32>;

    /// Retrieves an element by index from the List. Returns an error if there
    /// is a retrieval issue.
    ///
    /// # Arguments
    ///
    /// * `index` - The index of the element to retrieve.
    ///
    /// # Returns
    ///
    /// An `Option<T>` which is `None` if the list is empty, or
    /// `Some(value)` if an element was found, encapsulated
    /// in `SyscallResult`.
    fn get(self: @List<T>, index: u32) -> SyscallResult<Option<T>>;

    /// Sets the value of an element at a given index.
    ///
    /// # Arguments
    ///
    /// * `index` - The index of the element to modify.
    /// * `value` - The value to set at the given index.
    ///
    /// # Returns
    ///
    /// A result indicating success or encapsulating the error in `SyscallResult`.
    ///
    /// # Panics
    ///
    /// Panics if the index is out of bounds.
    fn set(ref self: List<T>, index: u32, value: T) -> SyscallResult<()>;

    /// Clears the List by setting its length to 0.
    ///
    /// The storage is not actually cleared, only the length is set to 0.
    /// The values can still be accessible using low-level syscalls, but cannot
    /// be accessed through the list interface.
    fn clean(ref self: List<T>);

    /// Removes and returns the first element of the List.
    ///
    /// The storage is not actually cleared, only the length is decreased by
    /// one.
    /// The value popped can still be accessible using low-level syscalls, but
    /// cannot be accessed through the list interface.
    /// # Returns
    ///
    /// An `Option<T>` which is `None` if the index is out of bounds, or
    /// `Some(value)` if an element was found at the given index, encapsulated
    /// in `SyscallResult`.
    fn pop_front(ref self: List<T>) -> SyscallResult<Option<T>>;

    /// Converts the List into an Array.  If the list cannot be converted
    /// to an array due storage errors, an error is returned.
    ///
    /// # Returns
    ///
    /// An `Array<T>` containing all the elements of the List, encapsulated
    /// in `SyscallResult`.
    fn array(self: @List<T>) -> SyscallResult<Array<T>>;
}

impl ListImpl<T, +Copy<T>, +Drop<T>, +Store<T>> of ListTrait<T> {
    #[inline(always)]
    fn new(address_domain: u32, base: StorageBaseAddress) -> List<T> {
        let storage_size: u8 = Store::<T>::size();
        List { address_domain, base, len: 0, storage_size }
    }

    #[inline(always)]
    fn fetch(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<List<T>> {
        ListStore::read(address_domain, base)
    }

    fn append_span(ref self: List<T>, mut span: Span<T>) -> SyscallResult<()> {
        let mut index = self.len;
        self.len += span.len();

        loop {
            match span.pop_front() {
                Option::Some(v) => {
                    let (base, offset) = calculate_base_and_offset_for_index(
                        self.base, index, self.storage_size
                    );
                    match Store::write_at_offset(self.address_domain, base, offset, *v) {
                        Result::Ok(_) => {},
                        Result::Err(e) => { break Result::Err(e); }
                    }
                    index += 1;
                },
                Option::None => { break Store::write(self.address_domain, self.base, self.len); }
            };
        }
    }

    #[inline(always)]
    fn len(self: @List<T>) -> u32 {
        *self.len
    }

    #[inline(always)]
    fn is_empty(self: @List<T>) -> bool {
        *self.len == 0
    }

    fn append(ref self: List<T>, value: T) -> SyscallResult<u32> {
        let (base, offset) = calculate_base_and_offset_for_index(
            self.base, self.len, self.storage_size
        );
        Store::write_at_offset(self.address_domain, base, offset, value)?;

        let append_at = self.len;
        self.len += 1;
        Store::write(self.address_domain, self.base, self.len)?;

        Result::Ok(append_at)
    }

    fn get(self: @List<T>, index: u32) -> SyscallResult<Option<T>> {
        if (index >= *self.len) {
            return Result::Ok(Option::None);
        }

        let (base, offset) = calculate_base_and_offset_for_index(
            *self.base, index, *self.storage_size
        );
        let t = Store::read_at_offset(*self.address_domain, base, offset)?;
        Result::Ok(Option::Some(t))
    }

    fn set(ref self: List<T>, index: u32, value: T) -> SyscallResult<()> {
        assert(index < self.len, 'List index out of bounds');
        let (base, offset) = calculate_base_and_offset_for_index(
            self.base, index, self.storage_size
        );
        Store::write_at_offset(self.address_domain, base, offset, value)
    }

    #[inline(always)]
    fn clean(ref self: List<T>) {
        self.len = 0;
        Store::write(self.address_domain, self.base, self.len);
    }

    fn pop_front(ref self: List<T>) -> SyscallResult<Option<T>> {
        if self.len == 0 {
            return Result::Ok(Option::None);
        }

        let popped = self.get(self.len - 1)?;
        // not clearing the popped value to save a storage write,
        // only decrementing the len - makes it unaccessible through
        // the interfaces, next append will overwrite the values
        self.len -= 1;
        Store::write(self.address_domain, self.base, self.len)?;

        Result::Ok(popped)
    }

    fn array(self: @List<T>) -> SyscallResult<Array<T>> {
        let mut array = array![];
        let mut index = 0;
        let result: SyscallResult<()> = loop {
            if index == *self.len {
                break Result::Ok(());
            }
            let value = match self.get(index) {
                Result::Ok(v) => v,
                Result::Err(e) => { break Result::Err(e); }
            }.expect('List index out of bounds');
            array.append(value);
            index += 1;
        };

        match result {
            Result::Ok(_) => Result::Ok(array),
            Result::Err(e) => Result::Err(e)
        }
    }
}

impl AListIndexViewImpl<T, +Copy<T>, +Drop<T>, +Store<T>> of IndexView<List<T>, u32, T> {
    fn index(self: @List<T>, index: u32) -> T {
        self.get(index).expect('read syscall failed').expect('List index out of bounds')
    }
}

// this functions finds the StorageBaseAddress of a "storage segment" (a continuous space of 256 storage slots)
// and an offset into that segment where a value at `index` is stored
// each segment can hold up to `256 // storage_size` elements
//
// the way how the address is calculated is very similar to how a LegacyHash map works:
//
// first we take the `list_base` address which is derived from the name of the storage variable
// then we hash it with a `key` which is the number of the segment where the element at `index` belongs (from 0 upwards)
// we hash these two values: H(list_base, key) to the the `segment_base` address
// finally, we calculate the offset into this segment, taking into account the size of the elements held in the array
//
// by way of example:
//
// say we have an List<Foo> and Foo's storage_size is 8
// struct storage: {
//    bar: List<Foo>
// }
//
// the storage layout would look like this:
//
// segment0: [0..31] - elements at indexes 0 to 31
// segment1: [32..63] - elements at indexes 32 to 63
// segment2: [64..95] - elements at indexes 64 to 95
// etc.
//
// where addresses of each segment are:
//
// segment0 = hash(bar.address(), 0)
// segment1 = hash(bar.address(), 1)
// segment2 = hash(bar.address(), 2)
//
// so for getting a Foo at index 90 this function would return address of segment2 and offset of 26

fn calculate_base_and_offset_for_index(
    list_base: StorageBaseAddress, index: u32, storage_size: u8
) -> (StorageBaseAddress, u8) {
    let max_elements = POW2_8 / storage_size.into();
    let (key, offset) = U32DivRem::div_rem(index, max_elements.try_into().unwrap());

    // hash the base address and the key which is the segment number
    let addr_elements = array![
        storage_address_to_felt252(storage_address_from_base(list_base)), key.into()
    ];
    let segment_base = storage_base_address_from_felt252(poseidon_hash_span(addr_elements.span()));

    (segment_base, offset.try_into().unwrap() * storage_size)
}

impl ListStore<T, +Store<T>> of Store<List<T>> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<List<T>> {
        let len: u32 = Store::read(address_domain, base).unwrap_syscall();
        let storage_size: u8 = Store::<T>::size();
        Result::Ok(List { address_domain, base, len, storage_size })
    }

    #[inline(always)]
    fn write(address_domain: u32, base: StorageBaseAddress, value: List<T>) -> SyscallResult<()> {
        Store::write(address_domain, base, value.len)
    }

    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8
    ) -> SyscallResult<List<T>> {
        let len: u32 = Store::read_at_offset(address_domain, base, offset).unwrap_syscall();
        let storage_size: u8 = Store::<T>::size();
        Result::Ok(List { address_domain, base, len, storage_size })
    }

    #[inline(always)]
    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8, value: List<T>
    ) -> SyscallResult<()> {
        Store::write_at_offset(address_domain, base, offset, value.len)
    }

    fn size() -> u8 {
        Store::<u8>::size()
    }
}
