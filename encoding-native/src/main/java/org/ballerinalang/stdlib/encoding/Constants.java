/*
 *  Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.stdlib.encoding;

import io.ballerina.runtime.api.Module;

import static io.ballerina.runtime.util.BLangConstants.BALLERINA_BUILTIN_PKG_PREFIX;

/**
 * Constants related to encoding module.
 */
public class Constants {

    public static final String PACKAGE_NAME = "encoding";
    public static final Module ENCODING_PACKAGE_ID =
            new Module(BALLERINA_BUILTIN_PKG_PREFIX, PACKAGE_NAME, "1.0.3");
    // Error type IDs
    public static final String ENCODING_ERROR = "EncodingError";
    public static final String DECODING_ERROR = "DecodingError";
}
