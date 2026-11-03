# Specification: Ballerina URL Library

_Owners_: @daneshk @TharmiganK @lnash94 @shafreenAnfar  
_Reviewers_:  
_Created_: 2026/11/03  
_Updated_: 2026/11/03  
_Edition_: Swan Lake  

## Introduction

This is the specification for the URL standard library of the [Ballerina language](https://ballerina.io/), which percent-encodes and decodes strings for use in URLs.

This specification is the contract of the library. It defines the observable behaviour of the library: the arguments it accepts, the strings it produces and the errors it returns. A behaviour of the implementation that differs from this specification is a bug in the implementation. A behaviour that this specification does not define is a gap in the specification, and is also reported as a bug. Signatures and per-symbol documentation are part of the [API documentation](https://central.ballerina.io/ballerina/url/latest), and usage examples are part of [Ballerina by Example](https://ballerina.io/learn/by-example/). Neither is repeated here.

The released versions of the specification can be found under the relevant GitHub tag. Changes to observable behaviour, including changes to this specification, are recorded in the `changelog.md` of the library. A change to documented behaviour follows the proposal process described in the [library development process](https://github.com/ballerina-platform/ballerina-library/blob/main/docs/library-development-process.md). If you have any feedback or suggestions about the library, start a discussion via a [GitHub issue](https://github.com/ballerina-platform/ballerina-library/issues) or in the [Discord server](https://discord.gg/ballerinalang).

### Notation

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY and OPTIONAL in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) and [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174) when, and only when, they appear in all capitals. Sentences that state behaviour in the present tense are also normative. Examples, notes and the overview are informative. Behaviour marked as _unspecified_ MUST NOT be relied upon, and behaviour marked as _implementation-defined_ is chosen and documented by the implementation.

Characters are written as Unicode code points, e.g. U+0020, or as quoted literals, e.g. `"~"`. Octets are written in hexadecimal, e.g. `0x7E`. Types and functions are written without the `url:` prefix when they belong to this library.

## Contents

- [1. Overview](#1-overview)
- [2. Terminology](#2-terminology)
- [3. Charsets](#3-charsets)
    - [3.1. Description](#31-description)
    - [3.2. Configuration](#32-configuration)
    - [3.3. Behaviour](#33-behaviour)
    - [3.4. Errors](#34-errors)
- [4. Encoding](#4-encoding)
    - [4.1. Description](#41-description)
    - [4.2. Configuration](#42-configuration)
    - [4.3. Behaviour](#43-behaviour)
    - [4.4. Errors](#44-errors)
- [5. Decoding](#5-decoding)
    - [5.1. Description](#51-description)
    - [5.2. Configuration](#52-configuration)
    - [5.3. Behaviour](#53-behaviour)
    - [5.4. Errors](#54-errors)
    - [5.5. Interactions](#55-interactions)
- [6. Errors](#6-errors)
    - [6.1. Description](#61-description)
    - [6.2. Behaviour](#62-behaviour)
- [7. Security considerations](#7-security-considerations)
- [References](#references)

## 1. Overview

The library provides two functions. The `encode` function converts a string into a form that contains only characters that are safe in any component of a URL, by converting every other character into octets using a named charset and writing each octet as a percent-encoded octet, as defined in [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986). The `decode` function reverses this, and also accepts the `+` notation for U+0020 used by `application/x-www-form-urlencoded` data.

The functions operate on single values, such as one path segment, one query parameter name or one query parameter value. They do not parse URLs: `encode` encodes the delimiters of a URL, such as `/`, `?` and `&`, like any other character. Both functions are isolated and keep no state between calls, so they can be called concurrently.

## 2. Terminology

- **Unreserved character**: one of the characters `A`–`Z`, `a`–`z`, `0`–`9`, `-`, `.`, `_` and `~`, as defined in section 2.3 of [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986#section-2.3).
- **Percent-encoded octet**: the character `%` followed by two hexadecimal digits, which represents the octet with that value, as defined in section 2.1 of [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986#section-2.1).
- **Charset**: a character encoding that maps characters to octet sequences and back, identified by a name, such as `UTF-8`.
- **ASCII-compatible charset**: a charset that encodes every character from U+0000 to U+007F as the single octet with the same value, such as `UTF-8`, `US-ASCII` and `ISO-8859-1`. `UTF-16` and EBCDIC charsets such as `IBM037` are not ASCII-compatible.

## 3. Charsets

### 3.1. Description

Both functions take the name of a charset, which determines how characters are converted to and from octets.

### 3.2. Configuration

| Argument  | Type     | Default    | Meaning                                                                                                                                                                                                                                                            |
|-----------|----------|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `charset` | `string` | `Required` | Name of the charset, matched case-insensitively. The canonical name of each supported charset is accepted; which aliases are accepted is _implementation-defined_. Any other name, including an empty name, is rejected as specified in [3.4. Errors](#34-errors). |

### 3.3. Behaviour

1. The implementation MUST support the charsets `US-ASCII`, `ISO-8859-1`, `UTF-8`, `UTF-16BE`, `UTF-16LE` and `UTF-16`. Which other charsets are supported is _implementation-defined_.
2. The charset name is validated on every call, before the value is processed, even when the value contains no character other than unreserved characters.
3. The charset is used only to convert characters that are not unreserved characters to octets in `encode`, and percent-encoded octets to characters in `decode`. Unreserved characters, and characters that `decode` copies unchanged, are not converted with the charset.
4. When a charset that is supported for decoding cannot be used for encoding, `encode` returns an `Error` if the value contains a character that is not an unreserved character. Whether `encode` returns an `Error` for a value that contains only unreserved characters is _unspecified_.

> **Note:** The set of charsets of rule 1 is the set every runtime guarantees. The other charsets available can differ between runtimes; for example, a GraalVM native image can support fewer charsets than the Java runtime.

For example, the charset determines the octets of a character that is encoded ([4.3. Behaviour](#43-behaviour) rule 2), and is not used for unreserved characters (rule 3):

```ballerina
string utf8 = check url:encode("é", "UTF-8");        // "%C3%A9" (4.3 rule 2)
string latin1 = check url:encode("é", "ISO-8859-1"); // "%E9" (4.3 rule 2)
string plain = check url:encode("abc-1", "US-ASCII");  // "abc-1": unreserved characters are not converted (rule 3)
```

### 3.4. Errors

| Condition                                                                                                       | Result                                                                                                     |
|-----------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| The charset name does not identify a supported charset, including an empty name                                 | `Error` returned, with the message prefix of the function as specified in [6.2. Behaviour](#62-behaviour). |
| The charset cannot be used for encoding, and the value contains a character that is not an unreserved character | `encode` returns an `Error`, with the message prefix `Error occurred while encoding.`                      |

## 4. Encoding

### 4.1. Description

The `encode` function percent-encodes every character of a string that is not an unreserved character, using the given charset.

### 4.2. Configuration

| Argument  | Type     | Default    | Meaning                                                                                       |
|-----------|----------|------------|-----------------------------------------------------------------------------------------------|
| `value`   | `string` | `Required` | The string to encode. Any string is accepted. An empty string encodes to an empty string.     |
| `charset` | `string` | `Required` | The charset used to convert characters to octets, as specified in [3. Charsets](#3-charsets). |

### 4.3. Behaviour

1. The function validates `charset` as specified in [3.3. Behaviour](#33-behaviour).
2. For an ASCII-compatible charset, the function processes `value` from the first character to the last, and appends to the result:
    1. an unreserved character, including `~`, as itself;
    2. for each maximal run of consecutive characters that are not unreserved characters, including U+0020 and `*`, the octets of the run converted with the charset, each written as a percent-encoded octet with two uppercase hexadecimal digits.
3. When `value` contains a character that the charset cannot represent, whether the function returns an `Error`, and which octets it writes for the character otherwise, are _unspecified_. `UTF-8`, `UTF-16BE`, `UTF-16LE` and `UTF-16` represent every string.
4. For a charset that is not ASCII-compatible, such as `UTF-16` or `IBM037`, whether the function returns an `Error`, and which octets it writes otherwise, are _unspecified_. A result it returns satisfies rule 5.
5. The result contains only unreserved characters and percent-encoded octets. In particular, it never contains `+`, U+0020 or `*`, and a U+0020 in `value` is written as the octets of U+0020 in the charset, e.g. `%20` in an ASCII-compatible charset.
6. The result depends only on `value` and `charset`. Calls keep no state, and concurrent calls do not affect each other.

For example, delimiters, U+0020, `+` and non-ASCII characters are encoded, and unreserved characters are not:

```ballerina
string encoded = check url:encode("a b+c*~/é", "UTF-8");
// encoded == "a%20b%2Bc%2A~%2F%C3%A9" (rules 2 and 5)
```

For example, each value of a query is encoded separately, so that its delimiters are not mistaken for those of the query:

```ballerina
string query = "q=" + check url:encode("C&C++ = fun", "UTF-8") + "&lang=" + check url:encode("en-US", "UTF-8");
// query == "q=C%26C%2B%2B%20%3D%20fun&lang=en-US" (rule 2)
```

### 4.4. Errors

| Condition                                    | Result                                                                     |
|----------------------------------------------|----------------------------------------------------------------------------|
| A charset error of [3.4. Errors](#34-errors) | `Error` returned, with the message prefix `Error occurred while encoding.` |

The function MUST NOT panic for any `value` and `charset`. When memory is exhausted while the function runs, whether it returns an `Error` or the program ends is _unspecified_.

## 5. Decoding

### 5.1. Description

The `decode` function replaces the percent-encoded octets of a string with the characters they encode in the given charset, and each `+` with U+0020.

### 5.2. Configuration

| Argument  | Type     | Default    | Meaning                                                                                                       |
|-----------|----------|------------|---------------------------------------------------------------------------------------------------------------|
| `value`   | `string` | `Required` | The string to decode. An empty string decodes to an empty string.                                             |
| `charset` | `string` | `Required` | The charset used to convert percent-encoded octets to characters, as specified in [3. Charsets](#3-charsets). |

### 5.3. Behaviour

1. The function validates `charset` as specified in [3.3. Behaviour](#33-behaviour).
2. The function processes `value` from the first character to the last, and appends to the result:
    1. for a maximal run of consecutive percent-encoded octets, the characters obtained by converting the octets of the run with the charset. The hexadecimal digits are case-insensitive, so `%7e` and `%7E` are equivalent;
    2. for `+`, U+0020;
    3. for any other character, including a non-ASCII character, the character itself.
3. If `value` contains a `%` that is not followed by two hexadecimal digits, including a `%` among the last two characters of `value`, whether the function returns an `Error` or copies the `%` and the characters after it is _unspecified_.
4. If the octets of a run in step 2.1 are not a valid octet sequence in the charset, the characters appended for the run are _unspecified_.
5. Decoding is applied once: a percent-encoded octet in the result, such as the `%2F` obtained from `%252F`, is not decoded again.
6. The result depends only on `value` and `charset`. Calls keep no state, and concurrent calls do not affect each other.
7. For `UTF-16`, the octets of each run in step 2.1 are read as big-endian unless they start with a byte order mark, which selects the byte order and is not part of the result. For `UTF-16BE`, `UTF-16LE` and `UTF-8`, a byte order mark is decoded as U+FEFF.

For example, percent-encoded octets in either case and `+` are decoded, and other characters are copied:

```ballerina
string decoded = check url:decode("a%20b+c%2B%c3%a9~", "UTF-8");
// decoded == "a b c+é~" (rule 2)
```

For example, the result of decoding is not decoded again:

```ballerina
string once = check url:decode("%252F", "UTF-8");
// once == "%2F" (rule 5)
```

### 5.4. Errors

| Condition                                    | Result                                                                     |
|----------------------------------------------|----------------------------------------------------------------------------|
| A charset error of [3.4. Errors](#34-errors) | `Error` returned, with the message prefix `Error occurred while decoding.` |
| A malformed percent-encoded octet (rule 3)   | _Unspecified_: an `Error` with the message prefix `Error occurred while decoding.`, or a result |

The function MUST NOT panic for any `value` and `charset`. When memory is exhausted while the function runs, whether it returns an `Error` or the program ends is _unspecified_.

### 5.5. Interactions

1. For an ASCII-compatible charset and a string `s` whose characters the charset can all represent, `decode(encode(s, charset), charset)` returns `s`.
2. `encode(decode(t, charset), charset)` does not necessarily return `t`: a `+` in `t` is encoded as the octets of U+0020, lowercase hexadecimal digits become uppercase, and a percent-encoded unreserved character, such as `%41`, becomes the character itself.

For example:

```ballerina
string original = "a+b c/é";
string roundTrip = check url:decode(check url:encode(original, "UTF-8"), "UTF-8");
// roundTrip == original (rule 1)

string reEncoded = check url:encode(check url:decode("a+b%2f%41", "UTF-8"), "UTF-8");
// reEncoded == "a%20b%2FA" (rule 2)
```

## 6. Errors

### 6.1. Description

`Error` is the distinct error type of the library.

### 6.2. Behaviour

Every failure of `encode` and `decode` is returned as an `Error`, except that the outcome of memory exhaustion is _unspecified_, as stated in [4.4. Errors](#44-errors) and [5.4. Errors](#54-errors).

1. The message of an `Error` returned by `encode` starts with `Error occurred while encoding.`, and that of an `Error` returned by `decode` starts with `Error occurred while decoding.`. The rest of the message is _implementation-defined_.
2. An `Error` has an empty detail record and no cause.

## 7. Security considerations

1. The result of `encode` contains only unreserved characters and percent-encoded octets, so it can be inserted into a path segment, a query parameter name or value, or a fragment without any of its characters being taken as a delimiter.
2. `encode` is applied to a single component. Applying it to a whole URL encodes the delimiters of the URL, and applying it twice encodes the `%` of the first result.
3. The result of `decode` may contain any character, including `/`, `?`, `#`, `%`, `..` sequences, control characters and U+0000. `decode` does not reject or escape any of them, so a check made on a value before decoding does not hold for the decoded value. Decoding a value twice decodes `%252F` to `/`.
4. `decode` decodes `+` as U+0020, as `application/x-www-form-urlencoded` does, so a literal `+` that is not percent-encoded, such as one in a path segment, is decoded as U+0020. `encode` always writes `+` as `%2B`.
5. The result of `decode` for octets that are not a valid sequence in the charset is _unspecified_ (see [5.3. Behaviour](#53-behaviour) rule 4). `decode` does not guarantee that such input is rejected, and different inputs may decode to the same string.
6. The result of `encode` for a character that the charset cannot represent is _unspecified_ (see [4.3. Behaviour](#43-behaviour) rule 3): it may be written as a replacement character without an error, so different values may encode to the same string. `UTF-8` represents every string.
7. Only the charsets of [3.3. Behaviour](#33-behaviour) rule 1 are guaranteed to be available on every runtime, including a GraalVM native image.
8. Neither function limits the length of `value`. For `UTF-8`, the result of `encode` is at most 12 times as long as `value`, since a character is at most 4 octets and each octet is written as 3 characters. Except as allowed by [5.3. Behaviour](#53-behaviour) rule 4, the result of `decode` is never longer than `value`. A `value` large enough to exhaust the available memory can end the program, so a value from an untrusted source should have its length limited before either function is called.

## References

- [RFC 3986: Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)
- [URL Standard: application/x-www-form-urlencoded](https://url.spec.whatwg.org/#application/x-www-form-urlencoded)
- [IANA Character Sets](https://www.iana.org/assignments/character-sets/character-sets.xhtml)
- [RFC 2119: Key words for use in RFCs to Indicate Requirement Levels](https://www.rfc-editor.org/rfc/rfc2119)
- [RFC 8174: Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words](https://www.rfc-editor.org/rfc/rfc8174)
