use cairo_lang_macro::{derive_macro, ProcMacroResult, TokenStream};
use cairo_lang_parser::utils::SimpleParserDatabase;
use cairo_lang_syntax::node::kind::SyntaxKind::{
    Member, OptionWrappedGenericParamListEmpty, TerminalStruct, TokenIdentifier,
    WrappedGenericParamList,
};

struct StructInfo {
    name: String,
    generic_params: Option<Vec<String>>,
    members: Vec<String>,
}

struct OpInfo {
    trait_name: String,
    fn_name: String,
    operator: String,
}

fn parse_struct_info(token_stream: TokenStream) -> StructInfo {
    let db = SimpleParserDatabase::default();
    let (parsed, _diag) = db.parse_virtual_with_diagnostics(token_stream);
    let mut nodes = parsed.descendants(&db);

    // find struct name - the next TokenIdentifier after TeminalStruct
    let mut struct_name = String::new();
    while let Some(node) = nodes.next() {
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
    while let Some(node) = nodes.next() {
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
    while let Some(node) = nodes.next() {
        if node.kind(&db) == Member {
            let member = node
                .descendants(&db)
                .find(|node| node.kind(&db) == TokenIdentifier)
                .map(|node| node.get_text(&db))
                .unwrap();
            members.push(member);
        }
    }

    StructInfo {
        name: struct_name,
        generic_params,
        members,
    }
}

fn generate_op_trait_impl(op_info: &OpInfo, s: &StructInfo) -> String {
    let generic_params = s
        .generic_params
        .as_ref()
        .map_or(String::new(), |params| format!("<{}>", params.join(", ")));

    let trait_bounds = s.generic_params.as_ref().map_or_else(
        || String::new(),
        |params| {
            let bounds = params
                .iter()
                .flat_map(|param| {
                    vec![
                        format!("+core::traits::{}<{}>", op_info.trait_name, param),
                        format!("+core::traits::Drop<{}>", param),
                    ]
                })
                .collect::<Vec<_>>()
                .join(",\n");
            format!("<{},\n{}>", params.join(", "), bounds)
        },
    );

    let members_op = s
        .members
        .iter()
        .map(|member| format!("{0}: lhs.{0} {1} rhs.{0}", member, op_info.operator))
        .collect::<Vec<_>>()
        .join(", ");

    format!(
        "\n
impl {0}{1}{2}
of core::traits::{1}<{0}{3}> {{
    fn {4}(lhs: {0}{3}, rhs: {0}{3}) -> {0}{3} {{
        {0} {{ {5} }}
    }}
}}\n",
        s.name, op_info.trait_name, trait_bounds, generic_params, op_info.fn_name, members_op
    )
}

fn generate_op_assign_trait_impl(op_info: &OpInfo, s: &StructInfo) -> String {
    let generic_params = s
        .generic_params
        .as_ref()
        .map_or(String::new(), |params| format!("<{}>", params.join(", ")));

    let trait_bounds = s.generic_params.as_ref().map_or_else(
        || String::new(),
        |params| {
            let bounds = params
                .iter()
                .flat_map(|param| {
                    vec![
                        format!("+core::ops::{0}Assign<{1}, {1}>", op_info.trait_name, param),
                        format!("+core::traits::Drop<{}>", param),
                    ]
                })
                .collect::<Vec<_>>()
                .join(",\n");
            format!("<{},\n{}>", params.join(", "), bounds)
        },
    );

    let members_op = s
        .members
        .iter()
        .map(|member| format!("self.{0} {1}= rhs.{0}", member, op_info.operator))
        .collect::<Vec<_>>()
        .join(";\n        ");

    format!(
        "\n
impl {0}{1}Assign{2}
of core::ops::{1}Assign<{0}{3}, {0}{3}> {{
    fn {4}_assign(ref self: {0}{3}, rhs: {0}{3}) {{
        {5};
    }}
}}\n",
        s.name, op_info.trait_name, trait_bounds, generic_params, op_info.fn_name, members_op
    )
}

// TODO: add macro docs so that they show in VSCode

#[derive_macro]
pub fn add(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Add".to_string(),
        fn_name: "add".to_string(),
        operator: "+".to_string(),
    };

    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_trait_impl(&op, &s)))
}

#[derive_macro]
pub fn sub(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Sub".to_string(),
        fn_name: "sub".to_string(),
        operator: "-".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_trait_impl(&op, &s)))
}

#[derive_macro]
pub fn mul(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Mul".to_string(),
        fn_name: "mul".to_string(),
        operator: "*".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_trait_impl(&op, &s)))
}

#[derive_macro]
pub fn div(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Div".to_string(),
        fn_name: "div".to_string(),
        operator: "/".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_trait_impl(&op, &s)))
}

#[derive_macro]
fn add_assign(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Add".to_string(),
        fn_name: "add".to_string(),
        operator: "+".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_assign_trait_impl(&op, &s)))
}

#[derive_macro]
fn sub_assign(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Sub".to_string(),
        fn_name: "sub".to_string(),
        operator: "-".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_assign_trait_impl(&op, &s)))
}

#[derive_macro]
fn mul_assign(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Mul".to_string(),
        fn_name: "mul".to_string(),
        operator: "*".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_assign_trait_impl(&op, &s)))
}

#[derive_macro]
fn div_assign(token_stream: TokenStream) -> ProcMacroResult {
    let op = OpInfo {
        trait_name: "Div".to_string(),
        fn_name: "div".to_string(),
        operator: "/".to_string(),
    };
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_op_assign_trait_impl(&op, &s)))
}
