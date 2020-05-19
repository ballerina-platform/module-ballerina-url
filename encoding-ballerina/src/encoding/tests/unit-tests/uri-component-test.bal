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
import ballerina/stringutils;
import ballerina/io;

@test:Config {
}
function testEncode() {
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

    foreach var u in urls {
        var results = encodeUriComponent(u, "UTF-8");
        if (results is string) {
            test:assertFalse(stringutils:contains(results, " "), msg = "Unexpected character");
            test:assertFalse(stringutils:contains(results, "*"), msg = "Unexpected character");
            test:assertFalse(stringutils:contains(results, "+"), msg = "Unexpected character");
            test:assertFalse(stringutils:contains(results, "%7E"), msg = "Unexpected character");
        } else {
            string? errMsg = results.detail()?.message;
            test:assertFail(msg = errMsg is string ? errMsg : "Error encodeUriComponent");
        }
    }
}

@test:Config {
    dependsOn: ["testEncode"]
}
function testInvalidEncode() {
    string url = "http://localhost:9090/echoService#abc";
    var results = encodeUriComponent(url, "abc");
    io:println(results);
    if (results is string) {
        test:assertFail(msg = "Expected {ballerina/encoding}Error not found");
    } else {
        string? errMsg = results.detail()?.message;
        string expectedErrMsg = "Error occurred while encoding the URI component. abc";
        test:assertEquals(errMsg, expectedErrMsg, "Unexpected error message");
    }
}

@test:Config {
    dependsOn: ["testInvalidEncode"]
}
function testSimpleUrlDecode() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090";
    string expectedUrl = "http://localhost:9090";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testSimpleUrlDecode"]
}
function testUrlDecodeWithSpaces() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Fhello%20world%2F";
    string expectedUrl = "http://localhost:9090/echoService/hello world/";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, " "), msg = "Decoded url string doesn't contain spaces.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithSpaces"]
}
function testUrlDecodeWithHashSign() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%23abc";
    string expectedUrl = "http://localhost:9090/echoService#abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, "#"), msg = "Decoded url string doesn't contain # character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithHashSign"]
}
function testUrlDecodeWithColon() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%3Aabc";
    string expectedUrl = "http://localhost:9090/echoService:abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, ":"), msg = "Decoded url string doesn't contain : character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithColon"]
}
function testUrlDecodeWithPlusSign() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Babc";
    string expectedUrl = "http://localhost:9090/echoService+abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, "+"), msg = "Decoded url string doesn't contain + character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithPlusSign"]
}
function testUrlDecodeWithAsterisk() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%2Aabc";
    string expectedUrl = "http://localhost:9090/echoService*abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, "*"), msg = "Decoded url string doesn't contain * character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithAsterisk"]
}
function testUrlDecodeWithPercentageMark() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService%25abc";
    string expectedUrl = "http://localhost:9090/echoService%abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, "%"), msg = "Decoded url string doesn't contain % character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithPercentageMark"]
}
function testUrlDecodeWithTilde() {
    string encodedUrlValue = "http%3A%2F%2Flocalhost%3A9090%2FechoService~abc";
    string expectedUrl = "http://localhost:9090/echoService~abc";
    var results = decodeUriComponent(encodedUrlValue, "UTF-8");
    if (results is string) {
        test:assertEquals(results, expectedUrl, msg = "Decoded url string is not correct.");
        test:assertTrue(stringutils:contains(results, "~"), msg = "Decoded url string doesn't contain ~ character.");
    } else {
        string? errMsg = results.detail()?.message;
        test:assertFail(msg = errMsg is string ? errMsg : "Error in decodeUriComponent");
    }
}

@test:Config {
    dependsOn: ["testUrlDecodeWithTilde"]
}
function testInvalidDecode() {
    string url = "http%3A%2F%2Flocalhost%3A9090%2FechoService~abc";
    var results = decodeUriComponent(url, "abc");
    io:println(results);
    if (results is string) {
        test:assertFail(msg = "Expected {ballerina/encoding}Error not found");
    } else {
        string? errMsg = results.detail()?.message;
        string expectedErrMsg = "Error occurred while decoding the URI component. abc";
        test:assertEquals(errMsg, expectedErrMsg, "Unexpected error message");
    }
}
