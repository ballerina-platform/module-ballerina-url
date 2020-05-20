//// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
////
//// WSO2 Inc. licenses this file to you under the Apache License,
//// Version 2.0 (the "License"); you may not use this file except
//// in compliance with the License.
//// You may obtain a copy of the License at
////
//// http://www.apache.org/licenses/LICENSE-2.0
////
//// Unless required by applicable law or agreed to in writing,
//// software distributed under the License is distributed on an
//// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//// KIND, either express or implied.  See the License for the
//// specific language governing permissions and limitations
//// under the License.
//
//import ballerina/test;
//
//@test:Config {
//}
//public function testEncodeBase64Url() {
//    string input = "Ballerina Base64 URL encoding test";
//    string expectedValue = "QmFsbGVyaW5hIEJhc2U2NCBVUkwgZW5jb2RpbmcgdGVzdA";
//    test:assertEquals(encodeBase64Url(input.toBytes()), expectedValue, msg = "Unexpected base64 encoding");
//}
//
//@test:Config {
//    dependsOn: ["testEncodeBase64Url"]
//}
//public function testDecodeBase64Url() {
//    string input = "QmFsbGVyaW5hIEJhc2U2NCBVUkwgZW5jb2RpbmcgdGVzdA";
//    string encodedString = "Ballerina Base64 URL encoding test";
//    byte[] expectedBytes = encodedString.toBytes();
//    var results = decodeBase64Url(input);
//
//    if (results is byte[]) {
//        test:assertEquals(results, expectedBytes, msg = "Unexpected base64 decoding");
//    } else {
//        string? errMsg = results.detail()?.message;
//        test:assertFail(msg = errMsg is string ? errMsg : "Unexpected results from decodeBase64Url");
//    }
//}
