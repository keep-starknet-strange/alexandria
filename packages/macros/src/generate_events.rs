use cairo_lang_macro::{attribute_macro, Diagnostic, ProcMacroResult, TokenStream};

#[attribute_macro]
pub fn generate_events(_attr: TokenStream, token_stream: TokenStream) -> ProcMacroResult {
    let input = token_stream.to_string();

    // Validate that this is applied to a proper event enum
    if let Err(validation_error) = validate_event_enum(&input) {
        return *validation_error;
    }

    // Extract struct names
    let struct_names = extract_struct_names(&input);

    // Generate structs with derives
    let structs = generate_structs(&struct_names);

    let cleaned_enum = clean_enum(&input);

    let output = format!("{cleaned_enum}\n{structs}");

    ProcMacroResult::new(TokenStream::new(output))
}

fn validate_event_enum(input: &str) -> Result<(), Box<ProcMacroResult>> {
    let lines: Vec<&str> = input.lines().collect();

    // Check 1: Must have #[event] attribute
    let has_event_attr = lines.iter().any(|line| line.trim().starts_with("#[event]"));

    if !has_event_attr {
        return Err(Box::new(error_result(
            "#[generate_events] can only be used on enums with #[event]",
        )));
    }

    // Check 2: Must have #[derive(..., starknet::Event, ...)]
    let has_starknet_event_derive = lines.iter().any(|line| {
        let trimmed = line.trim();
        trimmed.starts_with("#[derive(") && trimmed.contains("starknet::Event")
    });

    if !has_starknet_event_derive {
        return Err(Box::new(error_result(
            "#[generate_events] can only be used on enums that derive starknet::Event",
        )));
    }

    // Check 3: Must be a pub enum
    let has_pub_enum = lines.iter().any(|line| {
        let trimmed = line.trim();
        trimmed.starts_with("pub enum") || trimmed.contains("pub enum")
    });

    if !has_pub_enum {
        return Err(Box::new(error_result(
            "#[generate_events] can only be used on public enums.",
        )));
    }

    Ok(())
}

fn extract_struct_names(input: &str) -> Vec<String> {
    let mut struct_names = Vec::new();
    let mut inside_enum = false;

    for line in input.lines() {
        let trimmed = line.trim();

        if trimmed.contains("pub enum") {
            inside_enum = true;
            continue;
        }

        if inside_enum && trimmed == "}" {
            break;
        }

        if inside_enum && trimmed.contains(':') && !trimmed.is_empty() {
            if let Some(colon_idx) = trimmed.find(':') {
                let after_colon = &trimmed[colon_idx + 1..];
                let struct_name = after_colon.trim().trim_end_matches(',').trim();

                if !struct_name.is_empty() {
                    struct_names.push(struct_name.to_string());
                }
            }
        }
    }

    struct_names
}

fn generate_structs(struct_names: &[String]) -> String {
    struct_names.iter()
        .map(|name| {
            format!(
                "#[derive(Drop, starknet::Event)]\npub struct {name} {{\n    pub data: Span<felt252>,\n}}"
            )
        })
        .collect::<Vec<_>>()
        .join("\n\n")
}

fn clean_enum(input: &str) -> String {
    input
        .lines()
        .filter(|line| {
            let trimmed = line.trim();
            // Only remove #[generate_events] lines, keep everything else including #[derive(...)]
            !trimmed.starts_with("#[generate_events]")
        })
        .collect::<Vec<_>>()
        .join("\n")
}

fn error_result(msg: &str) -> ProcMacroResult {
    ProcMacroResult::new(TokenStream::empty()).with_diagnostics(Diagnostic::error(msg).into())
}
