use bigdecimal::num_bigint::BigInt;
use bigdecimal::{num_traits::pow, BigDecimal};

use cairo_lang_filesystem::ids::{FileKind, FileLongId, VirtualFile};
use cairo_lang_macro::{inline_macro, Diagnostic, ProcMacroResult, TokenStream};
use cairo_lang_parser::db::ParserGroup;
use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::ast::{ArgClause, Expr, ExprInlineMacro, WrappedArgList};
use cairo_lang_utils::{Intern, Upcast};

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
    // Get the ExprInlineMacro object so we can use the helper functions.
    let mac = parse_inline_macro(token_stream, &db);
    // Get the arguments of the macro. This macro expects a tuple as argument so we get the WrappedArgList::ParenthesizedArgList
    let macro_args = if let WrappedArgList::ParenthesizedArgList(args) = mac.arguments(db.upcast())
    {
        args.arguments(db.upcast()).elements(db.upcast())
    } else {
        vec![]
    };

    if macro_args.len() != 2 {
        return ProcMacroResult::new(TokenStream::empty())
            .with_diagnostics(Diagnostic::error("Invalid number of arguments").into());
    }
    let base = match get_arg_value(db.upcast(), &macro_args[0].arg_clause(db.upcast())) {
        Some(val) => val,
        None => {
            return ProcMacroResult::new(TokenStream::empty())
                .with_diagnostics(Diagnostic::error("Invalid base value").into())
        }
    }
    .into();

    let exp = match get_arg_value(db.upcast(), &macro_args[1].arg_clause(db.upcast())) {
        Some(val) => val,
        None => {
            return ProcMacroResult::new(TokenStream::empty())
                .with_diagnostics(Diagnostic::error("Invalid exponent value").into())
        }
    }
    .try_into();
    let exp = if let Ok(exponent) = exp {
        exponent
    } else {
        return ProcMacroResult::new(TokenStream::empty())
            .with_diagnostics(Diagnostic::error("Invalid exponent value").into());
    };

    let result: BigDecimal = pow(base, exp);

    ProcMacroResult::new(TokenStream::new(result.to_string()))
}

/// Return an [`ExprInlineMacro`] from the text received. The expected text is the macro arguments.
/// For example the initial macro text was `pow!(10, 3)`, the text in the token stream is only `(10, 3)`
fn parse_inline_macro(token_stream: impl ToString, db: &SimpleParserDatabase) -> ExprInlineMacro {
    // Create a virtual file that will be parsed.
    let file = FileLongId::Virtual(VirtualFile {
        parent: None,
        name: "parser_input".into(),
        content: format!("pow!{}", token_stream.to_string()).into(), // easiest workaround after change
        code_mappings: [].into(),
        kind: FileKind::Expr, // this part is different than db.parse_virtual
    })
    .intern(db);

    // Could fail if there was a parsing error but it shouldn't happen as the file has already
    // been parsed once to reach this macro.
    let node = db.file_expr_syntax(file).unwrap();

    let Expr::InlineMacro(inline_macro) = node else {
        panic!() // should not happen
    };

    inline_macro
}

/// Returns the value of a literal argument.
fn get_arg_value(db: &SimpleParserDatabase, arg_clause: &ArgClause) -> Option<BigInt> {
    let base_expr = match arg_clause {
        ArgClause::Unnamed(arg_clause) => arg_clause.value(db.upcast()),
        _ => return None,
    };
    if let Expr::Literal(base_lit) = base_expr {
        base_lit.numeric_value(db.upcast())
    } else {
        None
    }
}
