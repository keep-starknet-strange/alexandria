use cairo_lang_macro::TokenStream;
use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::kind::SyntaxKind::{
    ExprPath, Member, OptionWrappedGenericParamListEmpty, TerminalStruct, TokenIdentifier,
    WrappedGenericParamList,
};

pub(crate) struct FieldInfo {
    pub(crate) name: String,
    pub(crate) field_type: String,
}

pub(crate) struct StructInfo {
    pub(crate) name: String,
    pub(crate) generic_params: Option<Vec<String>>,
    pub(crate) fields: Vec<FieldInfo>,
    // Keep backward compatibility
    pub(crate) members: Vec<String>,
}

pub(crate) fn parse_struct_info(token_stream: TokenStream) -> StructInfo {
    let db = SimpleParserDatabase::default();
    let (parsed, _diag) = db.parse_virtual_with_diagnostics(token_stream);
    let mut nodes = parsed.descendants(&db);

    // find struct name - the next TokenIdentifier after TeminalStruct
    let mut struct_name = String::new();
    for node in nodes.by_ref() {
        if node.kind(&db) == TerminalStruct {
            struct_name = nodes
                .find(|node| node.kind(&db) == TokenIdentifier)
                .unwrap()
                .get_text(&db);
            break;
        }
    }

    // collect generic params or skip if there aren't any
    let mut generic_params: Option<Vec<String>> = None;
    for node in nodes.by_ref() {
        match node.kind(&db) {
            WrappedGenericParamList => {
                let params = node
                    .descendants(&db)
                    .filter(|node| node.kind(&db) == TokenIdentifier)
                    .map(|node| node.get_text(&db))
                    .collect();
                generic_params = Some(params);
                break;
            }
            OptionWrappedGenericParamListEmpty => {
                break;
            }
            _ => {}
        }
    }

    // collect struct members with their types
    let mut fields = Vec::new();
    let mut members = Vec::new(); // Keep for backward compatibility

    // Re-parse from the beginning to get member information
    let nodes = parsed.descendants(&db);

    for node in nodes {
        if node.kind(&db) == Member {
            let member_descendants: Vec<_> = node.descendants(&db).collect();

            // Find field name (first TokenIdentifier)
            let field_name = member_descendants
                .iter()
                .find(|n| n.kind(&db) == TokenIdentifier)
                .map(|n| n.get_text(&db))
                .unwrap_or_default();

            // Extract type information by looking for ExprPath node after colon
            let field_type = member_descendants
                .iter()
                .find(|n| n.kind(&db) == ExprPath)
                .map(|n| n.get_text(&db))
                .unwrap_or_default();

            if !field_name.is_empty() {
                fields.push(FieldInfo {
                    name: field_name.clone(),
                    field_type: if field_type.is_empty() {
                        "ByteArray".to_string()
                    } else {
                        field_type
                    },
                });
                members.push(field_name); // Backward compatibility
            }
        }
    }

    StructInfo {
        name: struct_name,
        generic_params,
        fields,
        members,
    }
}
