use cairo_lang_macro::TokenStream;
use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::kind::SyntaxKind::{
    Member, OptionWrappedGenericParamListEmpty, TerminalStruct, TokenColonColon, TokenIdentifier,
    TypeClause, WrappedGenericParamList,
};

pub(crate) struct MemberInfo {
    pub(crate) name: String,
    pub(crate) ty: String,
}

pub(crate) struct StructInfo {
    pub(crate) name: String,
    pub(crate) generic_params: Option<Vec<String>>,
    pub(crate) members: Vec<MemberInfo>,
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

    // collect struct members - all TokenIdentifier nodes after each Member
    let mut members = Vec::new();
    for node in nodes {
        if node.kind(&db) == Member {
            let mut name: Option<String> = None;
            let mut type_parts: Vec<String> = Vec::new();

            for descendant in node.descendants(&db) {
                match descendant.kind(&db) {
                    TypeClause => {
                        type_parts = descendant
                            .descendants(&db)
                            .filter(|n| {
                                let k = n.kind(&db);
                                k == TokenIdentifier || k == TokenColonColon
                            })
                            .map(|n| n.get_text(&db))
                            .collect();
                    }
                    TokenIdentifier => {
                        if name.is_none() {
                            name = Some(descendant.get_text(&db));
                        }
                    }
                    _ => {}
                }
            }

            if let (Some(name), false) = (name, type_parts.is_empty()) {
                let ty = type_parts.join("::");
                members.push(MemberInfo { name, ty });
            }
        }
    }

    StructInfo {
        name: struct_name,
        generic_params,
        members,
    }
}
