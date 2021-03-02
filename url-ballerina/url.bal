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

import ballerina/jballerina.java;

# Encodes the given string value into a `string` using the provided charset.
# ```ballerina
# string value = "param1=http://xyz.com/?a=12&b=55¶m2=99";
# string|url:Error encoded = url:encode(value, "UTF-8");
# ```
#
# + str - String to be encoded
# + charset - Character set to be used in encoding
# + return - The `string` value of the encoded string or an `Error` that occurred during encoding
public isolated function encode(string str, string charset) returns string|Error = @java:Method {
    'class: "org.ballerinalang.stdlib.url.nativeimpl.Encode"
} external;

# Decodes the given string value into a `string` using the provided charset.
# ```ballerina
# string value = "http://www.domain.com/?param1=http%3A%2F%2Fxyz.com%2F%3Fa%3D12%26b%3D55¶m2=99";
# string|url:Error decoded = url:decode(value, "UTF-8");
# ```
#
# + str - String to be decoded
# + charset - Character set to be used in decoding
# + return - The `string` value of the decoded string or an `Error` that occurred during decoding
public isolated function decode(string str, string charset) returns string|Error = @java:Method {
    'class: "org.ballerinalang.stdlib.url.nativeimpl.Decode"
} external;
