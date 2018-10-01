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

NS_ASSUME_NONNULL_BEGIN

@interface KLKLinkObject : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic, nullable) NSURL *webURL;
@property (copy, nonatomic, nullable) NSURL *mobileWebURL;
@property (copy, nonatomic, nullable) NSString *androidExecutionParams;
@property (copy, nonatomic, nullable) NSString *iosExecutionParams;

@end

@interface KLKLinkBuilder : NSObject

@property (copy, nonatomic, nullable) NSURL *webURL;
@property (copy, nonatomic, nullable) NSURL *mobileWebURL;
@property (copy, nonatomic, nullable) NSString *androidExecutionParams;
@property (copy, nonatomic, nullable) NSString *iosExecutionParams;

- (KLKLinkObject *)build;

@end

@interface KLKLinkObject (CreationWithBuilder)

+ (instancetype)linkObjectWithBuilderBlock:(void (^)(KLKLinkBuilder *linkBuilder))builderBlock;
+ (instancetype)linkObjectWithBuilder:(KLKLinkBuilder *)builder;
- (instancetype)initWithBuilder:(KLKLinkBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
