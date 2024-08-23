use bigdecimal::{num_traits::pow, BigDecimal};
use cairo_lang_macro::{inline_macro, Diagnostic, ProcMacroResult, TokenStream};
use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::kind::SyntaxKind::Arg;

/// Compile-time power function.
///
/// Takes two arguments, `x, y`, calculates the value of `x` raised to the power of `y`.
///
/// ```
/// const MEGABYTE: u64 = pow!(2, 20);
/// assert_eq!(MEGABYTE, 1048576);
/// ```
#[inline_macro]
pub fn pow(token_stream: TokenStream) -> ProcMacroResult {
    let db = SimpleParserDatabase::default();
    let (parsed, _diag) = db.parse_virtual_with_diagnostics(token_stream);

    let macro_args: Vec<String> = parsed
        .descendants(&db)
        .filter_map(|node| {
            if let Arg = node.kind(&db) {
                Some(node.get_text(&db))
            } else {
                None
            }
        })
        .collect();

    if macro_args.len() != 2 {
        return ProcMacroResult::new(TokenStream::empty())
            .with_diagnostics(Diagnostic::error("Invalid number of arguments").into());
    }

    let base: BigDecimal = match macro_args[0].parse() {
        Ok(val) => val,
        Err(_) => {
            return ProcMacroResult::new(TokenStream::empty())
                .with_diagnostics(Diagnostic::error("Invalid base value").into());
        }
    };

    let exp: usize = match macro_args[1].parse() {
        Ok(val) => val,
        Err(_) => {
            return ProcMacroResult::new(TokenStream::empty())
                .with_diagnostics(Diagnostic::error("Invalid exponent value").into());
        }
    };

    let result: BigDecimal = pow(base, exp);

    ProcMacroResult::new(TokenStream::new(result.to_string()))
}
