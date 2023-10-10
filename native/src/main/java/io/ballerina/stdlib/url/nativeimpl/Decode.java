/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.url.nativeimpl;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.url.UrlUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

/**
 * Extern functions of URL decoding.
 *
 * @since 0.991.0
 */
public final class Decode {

    private Decode() {}

    public static Object decode(BString str, BString charset) {
        try {
            return StringUtils.fromString(URLDecoder.decode(str.getValue(), charset.getValue()));
        } catch (UnsupportedEncodingException e) {
            return UrlUtils.createError("Error occurred while decoding. " + e.getMessage());
        }
    }
}
