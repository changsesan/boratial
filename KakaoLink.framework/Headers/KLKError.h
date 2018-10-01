/**
 * Copyright 2017 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

/*!
 @enum KakaoLink Error Codes
 @abstract Constants used by NSError to indicate errors in the KLKErrorDomain
 */
typedef NS_ENUM(NSInteger, KLKError)
{
    KLKErrorUnknown = 1,
    KLKErrorBadResponse = 7,
    KLKErrorNetwork = 8,
    KLKErrorHTTP = 9,
    KLKErrorBadParameter = 11,
    KLKErrorMisConfigured = 12,
    
    KLKErrorUnsupportedTalkVersion = 201,
    KLKErrorExceedSizeLimit = 202,
};

typedef NS_ENUM(NSInteger, KLKServerError)
{
    KLKServerErrorUnknown = -1,
    KLKServerErrorBadParameter = -2,
    KLKServerErrorUnSupportedApi = -3,
    KLKServerErrorBlocked = -4,
    KLKServerErrorAccessDenied = -5,
    KLKServerErrorMisConfigured = -6,
    KLKServerErrorInternal = -9,
    KLKServerErrorApiLimitExceed = -10,
    
    KLKServerErrorInvalidAppKey = -401,
    
    KLKServerErrorExceedMaxUploadSize = -602,
    KLKServerErrorExcutionTimeOut = -603,
    KLKServerErrorExceedMaxUploadNumber = -606,
    
    KLKServerErrorUnderMaintenance = -9798,
};

extern NSString *const KLKErrorDomain;
