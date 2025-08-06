use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::ast::TokenTreeNode;
use cairo_lang_syntax::node::TypedSyntaxNode;
use cairo_lang_utils::Upcast;

/// Comprehensive TokenTreeNode parsing examples for Cairo 2.12.0
///
/// This module demonstrates different approaches to parsing TokenTreeNode
/// which is the new format for macro arguments in Cairo 2.12.0
pub struct TokenTreeParser;

impl TokenTreeParser {
    /// Method 1: Simple string-based parsing
    ///
    /// Pros: Fast, simple to implement
    /// Cons: Less accurate, can't handle complex nested expressions well
    ///
    /// Use when: You have simple comma-separated literal arguments
    pub fn parse_simple_string(
        token_tree: &TokenTreeNode,
        db: &SimpleParserDatabase,
    ) -> Vec<String> {
        let token_str = token_tree.as_syntax_node().get_text(db.upcast());
        let content = token_str.trim_start_matches('(').trim_end_matches(')');

        if content.is_empty() {
            return vec![];
        }

        content
            .split(',')
            .map(|s| s.trim().to_string())
            .filter(|s| !s.is_empty())
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use cairo_lang_filesystem::ids::{FileKind, FileLongId, VirtualFile};
    use cairo_lang_parser::db::ParserGroup;
    use cairo_lang_syntax::node::ast::Expr;
    use cairo_lang_utils::Intern;

    fn create_test_token_tree(input: &str) -> (TokenTreeNode, SimpleParserDatabase) {
        let db = SimpleParserDatabase::default();

        let file = FileLongId::Virtual(VirtualFile {
            parent: None,
            name: "test_input".into(),
            content: format!("test_macro!{}", input).into(),
            code_mappings: [].into(),
            kind: FileKind::Expr,
            original_item_removed: false,
        })
        .intern(&db);

        let node = db.file_expr_syntax(file).expect("Parse error");

        if let Expr::InlineMacro(inline_macro) = node {
            (inline_macro.arguments(db.upcast()), db)
        } else {
            panic!("Expected inline macro")
        }
    }

    #[test]
    fn test_simple_string_parsing() {
        let (token_tree, db) = create_test_token_tree("(2, 10)");
        let args = TokenTreeParser::parse_simple_string(&token_tree, &db);
        assert_eq!(args, vec!["2", "10"]);
    }

    #[test]
    fn test_simple_string_parsing_with_expressions() {
        let (token_tree, db) = create_test_token_tree("(2 + 3, 4 * 5)");
        let args = TokenTreeParser::parse_simple_string(&token_tree, &db);
        assert_eq!(args.len(), 2);
        // The exact format may vary based on tokenization, but should contain the numbers
        assert!(args[0].contains("2") && args[0].contains("3"));
        assert!(args[1].contains("4") && args[1].contains("5"));
    }

    #[test]
    fn test_simple_string_parsing_multiple_args() {
        let (token_tree, db) = create_test_token_tree("(42, some_var, 100)");
        let args = TokenTreeParser::parse_simple_string(&token_tree, &db);
        assert_eq!(args.len(), 3);
        assert_eq!(args[0].trim(), "42");
        assert!(args[1].trim().contains("some_var"));
        assert_eq!(args[2].trim(), "100");
    }
}
