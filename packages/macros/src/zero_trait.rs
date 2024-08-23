use crate::parse::{parse_struct_info, StructInfo};
use cairo_lang_macro::{derive_macro, ProcMacroResult, TokenStream};

fn generate_zero_trait_impl(s: &StructInfo) -> String {
    let generic_params = s
        .generic_params
        .as_ref()
        .map_or(String::new(), |params| format!("<{}>", params.join(", ")));

    let trait_bounds = s
        .generic_params
        .as_ref()
        .map_or_else(String::new, |params| {
            let bounds = params
                .iter()
                .flat_map(|param| {
                    vec![
                        format!("+core::num::traits::Zero<{}>", param),
                        format!("+core::traits::Drop<{}>", param),
                    ]
                })
                .collect::<Vec<_>>()
                .join(",\n");
            format!("<{},\n{}>", params.join(", "), bounds)
        });

    let zero_fn = s
        .members
        .iter()
        .map(|member| format!("{}: core::num::traits::Zero::zero()", member))
        .collect::<Vec<_>>()
        .join(", ");

    let is_zero_fn = s
        .members
        .iter()
        .map(|member| format!("self.{}.is_zero()", member))
        .collect::<Vec<_>>()
        .join(" && ");

    format!(
        "\n
impl {0}ZeroImpl{1}
of core::num::traits::Zero<{0}{2}> {{
    fn zero() -> {0}{2} {{
        {0} {{ {3} }}
    }}

    fn is_zero(self: @{0}{2}) -> bool {{
        {4}
    }}

    fn is_non_zero(self: @{0}{2}) -> bool {{
        !self.is_zero()
    }}
}}\n",
        s.name, trait_bounds, generic_params, zero_fn, is_zero_fn
    )
}

/// Adds implementation of the `core::num::traits::Zero` trait.
///
/// All members of the struct must already implement the `Zero` trait.
///
/// ```
/// #[derive(Zero, PartialEq, Debug)]
/// struct Point {
///     x: u64,
///     y: u64,
/// }
///
/// assert_eq!(Point { x: 0, y: 0 }, Zero::zero());
/// assert!(Point { x: 0, y: 0 }.is_zero());
/// assert!(Point { x: 1, y: 0 }.is_non_zero());
/// ```
#[derive_macro]
pub fn zero(token_stream: TokenStream) -> ProcMacroResult {
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_zero_trait_impl(&s)))
}
