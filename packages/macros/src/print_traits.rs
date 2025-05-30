use crate::parse::{parse_struct_info, StructInfo};
use cairo_lang_macro::{derive_macro, Diagnostic, ProcMacroResult, TokenStream};

pub fn generate_display_impl(s: &StructInfo, supported_primitives: &[&str]) -> String {
    let struct_name = &s.name;

    let generic_params = s
        .generic_params
        .as_ref()
        .map_or(String::new(), |params| format!("<{}>", params.join(", ")));

    // Format string like: "StructName(x: {}, y: {}, z: {})"
    let format_string = s
        .members
        .iter()
        .map(|m| format!("{}: {{}}", m.name))
        .collect::<Vec<_>>()
        .join(", ");

    // Accessors like: self.x, self.y, self.z
    let field_accesses = s
        .members
        .iter()
        .map(|m| format!("self.{}", m.name))
        .collect::<Vec<_>>()
        .join(", ");

    let mut output = format!(
        r#"
        use {0}PrintMacro::{0}Display;
        pub mod {0}PrintMacro {{
            use super::{0};
            use core::fmt::{{Display, Formatter, Error}};
            pub impl {0}Display of Display<{0}{1}> {{
                fn fmt(self: @{0}{1}, ref f: Formatter) -> Result<(), Error> {{
                    let str: ByteArray = format!("{0}({2})", {3});
                    f.buffer.append(@str);
                    Ok(())
                }}
            }}
    "#,
        struct_name, generic_params, format_string, field_accesses
    );

    // Only generates the ContractAddressDisplay implementation if any member uses "ContractAddress"
    let needs_contract_display = s.members.iter().any(|m| m.ty.contains("ContractAddress"));

    if needs_contract_display {
        output += r#"
        use starknet::ContractAddress;
        impl ContractAddressDisplay of Display<ContractAddress> {
            fn fmt(self: @ContractAddress, ref f: Formatter) -> Result<(), Error> {
                let str: ByteArray = format!("0x{:x}", *self);
                f.buffer.append(@str);
                Ok(())
            }
        }
        "#;
    }

    // Check if any member uses "Array" and generate the corresponding implementation
    let mut printed_array_impls = Vec::new();

    for m in &s.members {
        if let Some(inner_type) = m.ty.strip_prefix("Array::") {
            if supported_primitives.contains(&inner_type)
                && !printed_array_impls.contains(&inner_type.to_string())
            {
                printed_array_impls.push(inner_type.to_string());
            }
        }
    }

    for inner_type in printed_array_impls {
        let mut inner_type_extended = inner_type.clone();
        if inner_type != "felt252" {
            inner_type_extended = format!("integer::{}", inner_type);
        }
        output += &format!(
            r#"
    impl DisplayArray{0} of Display<core::array::Array::<core::{1}>> {{
        fn fmt(self: @core::array::Array::<core::{1}>, ref f: Formatter) -> Result<(), Error> {{
            let mut str: ByteArray = format!("Array(");
            let mut first = true;
            let mut index = 0;
            loop {{
                if index >= self.len() {{
                    break;
                }}
                if !first {{
                    str = format!("{{}}, ", str);
                }} else {{
                    first = false;
                }}
                str = format!("{{}}{{}}", str, *self.at(index));
                index += 1;
            }}
            str = format!("{{}})", str);
            f.buffer.append(@str);
            Ok(())
        }}
    }}
    "#,
            inner_type, inner_type_extended
        );
    }
    output += "\n}";
    output
}

#[derive_macro]
pub fn print_struct(token_stream: TokenStream) -> ProcMacroResult {
    let s = parse_struct_info(token_stream);

    let supported_primitives = [
        "u8", "u16", "u32", "u64", "u128", "u256", "i8", "i16", "i32", "i64", "i128", "i256",
        "felt252", "bool",
    ];

    let mut unsupported_types = Vec::new();

    for m in &s.members {
        let ty = &m.ty;
        let is_supported = supported_primitives.contains(&ty.as_str())
            || ty == "ContractAddress"
            || ty == "core::starknet::ContractAddress"
            || ty.starts_with("Array::") && {
                let inner = ty.strip_prefix("Array::").unwrap_or("");
                supported_primitives.contains(&inner)
            }
            || ty.starts_with("core::array::Array::<") && {
                let inner_opt = ty
                    .strip_prefix("core::array::Array::<")
                    .and_then(|s| s.strip_suffix('>'));
                if let Some(inner) = inner_opt {
                    inner == "core::starknet::ContractAddress"
                        || inner.starts_with("core::integer::")
                            && supported_primitives
                                .contains(&inner.strip_prefix("core::integer::").unwrap_or(""))
                } else {
                    false
                }
            };

        if !is_supported {
            unsupported_types.push(ty.clone());
        }
    }

    if !unsupported_types.is_empty() {
        let msg = format!(
            "PrintStruct does not support the following field types: {}",
            unsupported_types.join(", ")
        );
        return ProcMacroResult::new(TokenStream::empty())
            .with_diagnostics(Diagnostic::error(&msg).into());
    }

    ProcMacroResult::new(TokenStream::new(generate_display_impl(
        &s,
        &supported_primitives,
    )))
}
