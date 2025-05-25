#[derive(Clone, Drop, Serde)]
pub struct EVMCalldata {
    pub calldata: ByteArray,
    pub offset: usize,
    pub relative_offset: usize,
}

