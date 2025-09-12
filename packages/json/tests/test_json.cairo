use alexandria_json::json::{JsonError, JsonValue, parse_json};
use alexandria_math::decimal::DecimalTrait;

#[test]
fn test_parse_null() {
    let result = parse_json("null");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Null);
}

#[test]
fn test_parse_bool_true() {
    let result = parse_json("true");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Bool(true));
}

#[test]
fn test_parse_bool_false() {
    let result = parse_json("false");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Bool(false));
}

#[test]
fn test_parse_number_positive() {
    let result = parse_json("123");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Number(123));
}

#[test]
fn test_parse_number_negative() {
    let result = parse_json("-42");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Number(-42));
}

#[test]
fn test_parse_number_zero() {
    let result = parse_json("0");
    assert!(result.is_ok());
    assert!(result.unwrap() == JsonValue::Number(0));
}

#[test]
fn test_parse_string_simple() {
    let result = parse_json("\"hello\"");
    assert!(result.is_ok());
    if let JsonValue::String(s) = result.unwrap() {
        assert!(s == "hello");
    }
}

#[test]
fn test_parse_string_empty() {
    let result = parse_json("\"\"");
    assert!(result.is_ok());
    if let JsonValue::String(s) = result.unwrap() {
        assert!(s.len() == 0);
    }
}

#[test]
fn test_parse_array_empty() {
    let result = parse_json("[]");
    assert!(result.is_ok());
    if let JsonValue::Array(arr) = result.unwrap() {
        assert!(arr.len() == 0);
    }
}

#[test]
fn test_parse_object_empty() {
    let result = parse_json("{}");
    assert!(result.is_ok());
    if let JsonValue::Object(obj) = result.unwrap() {
        assert!(obj.len() == 0);
    }
}

#[test]
fn test_parse_simple_array_with_values() {
    let result = parse_json("[1, 2, 3]");
    assert!(result.is_ok());
    if let JsonValue::Array(arr) = result.unwrap() {
        assert!(arr.len() == 3);
        if let JsonValue::Number(n1) = arr.at(0) {
            assert!(*n1 == 1);
        } else {
            panic!("Expected number at index 0");
        }
        if let JsonValue::Number(n2) = arr.at(1) {
            assert!(*n2 == 2);
        } else {
            panic!("Expected number at index 1");
        }
        if let JsonValue::Number(n3) = arr.at(2) {
            assert!(*n3 == 3);
        } else {
            panic!("Expected number at index 2");
        }
    } else {
        panic!("Expected array value");
    }
}

#[test]
fn test_parse_simple_object() {
    let result = parse_json("{\"name\": \"tom\", \"email\": \"tom@starknet.com\", \"age\": 30}");
    assert!(result.is_ok());
    if let JsonValue::Object(obj) = result.unwrap() {
        assert!(obj.len() == 3);

        let (key1, value1) = obj.at(0);
        assert!(key1 == @"name");
        if let JsonValue::String(s) = value1 {
            assert!(s == @"tom");
        } else {
            panic!("Expected string value for name");
        }

        let (key2, value2) = obj.at(1);
        assert!(key2 == @"email");
        if let JsonValue::String(email) = value2 {
            assert!(email == @"tom@starknet.com");
        } else {
            panic!("Expected string value for email");
        }

        let (key3, value3) = obj.at(2);
        assert!(key3 == @"age");
        if let JsonValue::Number(n) = value3 {
            assert!(*n == 30);
        } else {
            panic!("Expected number value for age");
        }
    } else {
        panic!("Expected object value");
    }
}

#[test]
fn test_parse_error_unexpected_character() {
    let result = parse_json("invalid");
    assert!(result.is_err());
    assert!(result.unwrap_err() == JsonError::UnexpectedCharacter);
}

#[test]
fn test_parse_error_unexpected_end() {
    let result = parse_json("\"unclosed string");
    assert!(result.is_err());
    assert!(result.unwrap_err() == JsonError::InvalidString);
}

#[test]
fn test_parse_error_invalid_number() {
    let result = parse_json("-");
    assert!(result.is_err());
    assert!(result.unwrap_err() == JsonError::InvalidNumber);
}

#[test]
fn test_parse_duplicate_keys_error() {
    let json = "{\"a\":123, \"a\":433}";
    let result = parse_json(json);
    // Should detect duplicate keys and return a specific DuplicateKey error
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::DuplicateKey);
}

#[test]
fn test_parse_duplicate_keys_complex() {
    let json = "{\"name\": \"Alice\", \"age\": 25, \"active\": true, \"name\": \"Bob\"}";
    let result = parse_json(json);
    // Should detect duplicate 'name' key and return DuplicateKey error
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::DuplicateKey);
}

#[test]
fn test_decimal_numbers_now_supported() {
    // Decimal numbers are now supported and parsed as JsonValue::Decimal
    let result1 = parse_json("3.14");
    assert!(result1.is_ok());

    if let JsonValue::Decimal(d) = result1.unwrap() {
        assert!(d.int_part() == 3); // Integer part is 3
    } else {
        panic!("Expected decimal");
    }

    // Test another decimal number
    let result2 = parse_json("42.5");
    assert!(result2.is_ok());
    if let JsonValue::Decimal(d) = result2.unwrap() {
        assert!(d.int_part() == 42); // Integer part is 42
    } else {
        panic!("Expected decimal");
    }

    // Integer numbers are still parsed as JsonValue::Number
    let result3 = parse_json("100");
    assert!(result3.is_ok());
    if let JsonValue::Number(n) = result3.unwrap() {
        assert!(n == 100); // Still integer
    } else {
        panic!("Expected number");
    }
}

#[test]
fn test_parse_email_address() {
    // Test parsing JSON with email address values
    let result1 = parse_json("\"user@example.com\"");
    assert!(result1.is_ok());
    if let JsonValue::String(s) = result1.unwrap() {
        assert!(s == "user@example.com");
    } else {
        panic!("Expected string value for email");
    }

    // Test email in object context
    let result2 = parse_json("{\"email\": \"john.doe@company.org\", \"verified\": true}");
    assert!(result2.is_ok());
    if let JsonValue::Object(obj) = result2.unwrap() {
        assert!(obj.len() == 2);

        let (email_key, email_value) = obj.at(0);
        assert!(email_key == @"email");
        if let JsonValue::String(email_str) = email_value {
            assert!(email_str == @"john.doe@company.org");
        } else {
            panic!("Expected string value for email");
        }

        let (verified_key, verified_value) = obj.at(1);
        assert!(verified_key == @"verified");
        if let JsonValue::Bool(b) = verified_value {
            assert!(*b == true);
        } else {
            panic!("Expected boolean value for verified");
        }
    } else {
        panic!("Expected object value");
    }

    // Test complex email with special characters
    let result3 = parse_json("{\"contact\": \"user+tag@sub.domain.co.uk\"}");
    assert!(result3.is_ok());
    if let JsonValue::Object(obj) = result3.unwrap() {
        let (key, value) = obj.at(0);
        assert!(key == @"contact");
        if let JsonValue::String(email) = value {
            assert!(email == @"user+tag@sub.domain.co.uk");
        } else {
            panic!("Expected string value for complex email");
        }
    }
}

#[test]
fn test_parse_special_characters_in_strings() {
    // Test various special characters that are common in real-world JSON

    // Test URL
    let result1 = parse_json("\"https://api.example.com/v1/users?id=123\"");
    assert!(result1.is_ok());
    if let JsonValue::String(s) = result1.unwrap() {
        assert!(s == "https://api.example.com/v1/users?id=123");
    }

    // Test file path
    let result2 = parse_json("\"/home/user/documents/file.txt\"");
    assert!(result2.is_ok());
    if let JsonValue::String(s) = result2.unwrap() {
        assert!(s == "/home/user/documents/file.txt");
    }

    // Test UUID
    let result3 = parse_json("\"550e8400-e29b-41d4-a716-446655440000\"");
    assert!(result3.is_ok());
    if let JsonValue::String(s) = result3.unwrap() {
        assert!(s == "550e8400-e29b-41d4-a716-446655440000");
    }

    // Test mixed special characters
    let result4 = parse_json(
        "{\"id\": \"user_123\", \"url\": \"https://example.com/path?param=value&other=123\"}",
    );
    assert!(result4.is_ok());
    if let JsonValue::Object(obj) = result4.unwrap() {
        assert!(obj.len() == 2);

        let (id_key, id_value) = obj.at(0);
        assert!(id_key == @"id");
        if let JsonValue::String(id_str) = id_value {
            assert!(id_str == @"user_123");
        }

        let (url_key, url_value) = obj.at(1);
        assert!(url_key == @"url");
        if let JsonValue::String(url_str) = url_value {
            assert!(url_str == @"https://example.com/path?param=value&other=123");
        }
    }
}

#[test]
fn test_parse_string_starting_with_boolean_letters() {
    // Test strings that start with 't', 'f', or 'n' to ensure they're not confused with
    // booleans/null
    let result1 = parse_json("\"true_value\"");
    assert!(result1.is_ok());
    if let JsonValue::String(s) = result1.unwrap() {
        assert!(s == "true_value");
    }

    let result2 = parse_json("\"false_flag\"");
    assert!(result2.is_ok());
    if let JsonValue::String(s) = result2.unwrap() {
        assert!(s == "false_flag");
    }

    let result3 = parse_json("\"null_pointer\"");
    assert!(result3.is_ok());
    if let JsonValue::String(s) = result3.unwrap() {
        assert!(s == "null_pointer");
    }

    let result4 = parse_json("\"frida\"");
    assert!(result4.is_ok());
    if let JsonValue::String(s) = result4.unwrap() {
        assert!(s == "frida");
    }
}

#[test]
fn test_parse_complex_nested_json() {
    // {"menu": {
    //   "id": "file",
    //   "value": "File",
    //   "popup": {
    //     "menuitem": [
    //       {"value": "New", "onclick": "CreateNewDoc()"},
    //       {"value": "Open", "onclick": "OpenDoc()"},
    //       {"value": "Close", "onclick": "CloseDoc()"}
    //     ]
    //   }
    // }}

    let json_str =
        "{\"menu\": {\"id\": \"file\", \"value\": \"File\", \"popup\": {\"menuitem\": [{\"value\": \"New\", \"onclick\": \"CreateNewDoc()\"}, {\"value\": \"Open\", \"onclick\": \"OpenDoc()\"}, {\"value\": \"Close\", \"onclick\": \"CloseDoc()\"}]}}}";
    let result = parse_json(json_str);
    assert!(result.is_ok());

    if let JsonValue::Object(root_obj) = result.unwrap() {
        assert!(root_obj.len() == 1);

        // Get the "menu" object
        let (menu_key, menu_value) = root_obj.at(0);
        assert!(menu_key == @"menu");

        if let JsonValue::Object(menu_obj) = menu_value {
            assert!(menu_obj.len() == 3);

            // Check "id" field
            let (id_key, id_value) = menu_obj.at(0);
            assert!(id_key == @"id");
            if let JsonValue::String(id_str) = id_value {
                assert!(id_str == @"file");
            } else {
                panic!("Expected string value for id");
            }

            // Check "value" field
            let (value_key, value_value) = menu_obj.at(1);
            assert!(value_key == @"value");
            if let JsonValue::String(value_str) = value_value {
                assert!(value_str == @"File");
            } else {
                panic!("Expected string value for value");
            }

            // Check "popup" field
            let (popup_key, popup_value) = menu_obj.at(2);
            assert!(popup_key == @"popup");

            if let JsonValue::Object(popup_obj) = popup_value {
                assert!(popup_obj.len() == 1);

                // Check "menuitem" array
                let (menuitem_key, menuitem_value) = popup_obj.at(0);
                assert!(menuitem_key == @"menuitem");

                if let JsonValue::Array(menuitem_array) = menuitem_value {
                    assert!(menuitem_array.len() == 3);

                    // Check first menu item
                    if let JsonValue::Object(item1) = menuitem_array.at(0) {
                        assert!(item1.len() == 2);

                        let (item1_value_key, item1_value_value) = item1.at(0);
                        assert!(item1_value_key == @"value");
                        if let JsonValue::String(item1_value_str) = item1_value_value {
                            assert!(item1_value_str == @"New");
                        } else {
                            panic!("Expected string value for first item value");
                        }

                        let (item1_onclick_key, item1_onclick_value) = item1.at(1);
                        assert!(item1_onclick_key == @"onclick");
                        if let JsonValue::String(item1_onclick_str) = item1_onclick_value {
                            assert!(item1_onclick_str == @"CreateNewDoc()");
                        } else {
                            panic!("Expected string value for first item onclick");
                        }
                    } else {
                        panic!("Expected object for first menu item");
                    }

                    // Check second menu item
                    if let JsonValue::Object(item2) = menuitem_array.at(1) {
                        let (item2_value_key, item2_value_value) = item2.at(0);
                        assert!(item2_value_key == @"value");
                        if let JsonValue::String(item2_value_str) = item2_value_value {
                            assert!(item2_value_str == @"Open");
                        } else {
                            panic!("Expected string value for second item value");
                        }
                    } else {
                        panic!("Expected object for second menu item");
                    }

                    // Check third menu item
                    if let JsonValue::Object(item3) = menuitem_array.at(2) {
                        let (item3_value_key, item3_value_value) = item3.at(0);
                        assert!(item3_value_key == @"value");
                        if let JsonValue::String(item3_value_str) = item3_value_value {
                            assert!(item3_value_str == @"Close");
                        } else {
                            panic!("Expected string value for third item value");
                        }
                    } else {
                        panic!("Expected object for third menu item");
                    }
                } else {
                    panic!("Expected array for menuitem");
                }
            } else {
                panic!("Expected object for popup");
            }
        } else {
            panic!("Expected object for menu");
        }
    } else {
        panic!("Expected object at root level");
    }
}

#[test]
fn test_parse_signed_decimal_negative() {
    // Test parsing negative decimal values
    let result = parse_json("-3.5");
    assert!(result.is_ok());

    if let JsonValue::Decimal(d) = result.unwrap() {
        assert!(d.int_part() == 3);
        assert!(d.is_negative() == true);
    } else {
        panic!("Expected decimal for -3.5");
    }
}

#[test]
fn test_parse_signed_decimal_positive() {
    // Test parsing positive decimal values (should work as before)
    let result = parse_json("3.5");
    assert!(result.is_ok());

    if let JsonValue::Decimal(d) = result.unwrap() {
        assert!(d.int_part() == 3);
        assert!(d.is_negative() == false);
    } else {
        panic!("Expected decimal for 3.5");
    }
}

#[test]
fn test_parse_signed_decimal_zero() {
    // Test parsing zero decimal
    let result = parse_json("0.0");
    assert!(result.is_ok());

    if let JsonValue::Decimal(d) = result.unwrap() {
        assert!(d.int_part() == 0);
        assert!(d.is_negative() == false);
    } else {
        panic!("Expected decimal for 0.0");
    }
}

#[test]
fn test_parse_signed_decimal_negative_zero() {
    // Test parsing negative zero decimal
    let result = parse_json("-0.0");
    assert!(result.is_ok());

    if let JsonValue::Decimal(d) = result.unwrap() {
        assert!(d.int_part() == 0);
        assert!(d.is_negative() == true); // Should preserve the negative sign even for zero
    } else {
        panic!("Expected decimal for -0.0");
    }
}

#[test]
fn test_parse_signed_decimal_in_object() {
    // Test signed decimals in JSON objects
    let result = parse_json("{\"temperature\": -15.7, \"humidity\": 65.2}");
    assert!(result.is_ok());

    if let JsonValue::Object(obj) = result.unwrap() {
        assert!(obj.len() == 2);

        let (temp_key, temp_value) = obj.at(0);
        assert!(temp_key == @"temperature");
        if let JsonValue::Decimal(d) = temp_value {
            assert!(d.int_part() == 15);
            assert!(d.is_negative() == true);
        } else {
            panic!("Expected decimal for temperature");
        }

        let (hum_key, hum_value) = obj.at(1);
        assert!(hum_key == @"humidity");
        if let JsonValue::Decimal(d) = hum_value {
            assert!(d.int_part() == 65);
            assert!(d.is_negative() == false);
        } else {
            panic!("Expected decimal for humidity");
        }
    } else {
        panic!("Expected object");
    }
}
