// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

@test:Config {}
isolated function testEncode() returns Error? {
    string[] urls = [
        "http://localhost:9090",
        "http://localhost:9090/echoService/hello world/",
        "http://localhost:9090/echoService?type=string&value=hello world",
        "http://localhost:9090/echoService#abc",
        "http://localhost:9090/echoService:abc",
        "http://localhost:9090/echoService+abc",
        "http://localhost:9090/echoService*abc",
        "http://localhost:9090/echoService%abc",
        "http://localhost:9090/echoService~abc"
    ];
    foreach string url in urls {
        string result = check encode(url, "UTF-8");
        test:assertFalse(result.includes(" "), "Unexpected character.");
        test:assertFalse(result.includes("*"), "Unexpected character.");
        test:assertFalse(result.includes("+"), "Unexpected character.");
        test:assertFalse(result.includes("%7E"), "Unexpected character.");
    }
}

@test:Config {}
isolated function testInvalidEncode() {
    string url = "http://localhost:9090/echoService#abc";
    string|Error result = encode(url, "abc");
    if result is Error {
        test:assertEquals(result.message(), "Error occurred while encoding. abc", "Unexpected error message.");
    } else {
        test:assertFail("Expected error not found.");
    }
}

@test:Config {}
isolated function testSimpleUrlDecode() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090");
}

@test:Config {}
isolated function testUrlDecodeWithSpaces() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Fhello%20world%2F";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService/hello world/");
    test:assertTrue(result.includes(" "));
}

@test:Config {}
isolated function testUrlDecodeWithHashSign() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%23abc";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService#abc");
    test:assertTrue(result.includes("#"));
}

@test:Config {}
isolated function testUrlDecodeWithColon() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%3Aabc";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService:abc");
    test:assertTrue(result.includes(":"));
}

@test:Config {}
isolated function testUrlDecodeWithPlusSign() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Babc";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService+abc");
    test:assertTrue(result.includes("+"));
}

@test:Config {}
isolated function testUrlDecodeWithAsterisk() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Aabc";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService*abc");
    test:assertTrue(result.includes("*"));
}

@test:Config {}
isolated function testUrlDecodeWithPercentageMark() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService%25abc";
    string result = check decode(encodedUrl, "UTF-8");
    test:assertEquals(result, "http://localhost:9090/echoService%abc");
    test:assertTrue(result.includes("%"));
}

@test:Config {}
isolated function testUrlDecodeWithTilde() returns Error? {
    string encodedUrl = "http%3A%2F%2Flocalhost%3A9090%2FechoService~abc";
    string result = check decode(encodedUrl, "UTF-8");
    string expectedUrl = "http://localhost:9090/echoService~abc";
    test:assertEquals(result, "http://localhost:9090/echoService~abc");
    test:assertTrue(result.includes("~"));
}

@test:Config {}
isolated function testInvalidDecode() {
    string url = "http%3A%2F%2Flocalhost%3A9090%2FechoService~abc";
    string|Error result = decode(url, "abc");
    if result is Error {
        test:assertEquals(result.message(), "Error occurred while decoding. abc", "Unexpected error message.");
    } else {
        test:assertFail("Expected error not found.");
    }
}
