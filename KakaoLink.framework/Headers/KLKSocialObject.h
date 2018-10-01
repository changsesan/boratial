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

@interface KLKSocialObject : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic, nullable) NSNumber *likeCount;
@property (copy, nonatomic, nullable) NSNumber *commnentCount;
@property (copy, nonatomic, nullable) NSNumber *sharedCount;
@property (copy, nonatomic, nullable) NSNumber *viewCount;
@property (copy, nonatomic, nullable) NSNumber *subscriberCount;

@end

@interface KLKSocialBuilder : NSObject

@property (copy, nonatomic, nullable) NSNumber *likeCount;
@property (copy, nonatomic, nullable) NSNumber *commnentCount;
@property (copy, nonatomic, nullable) NSNumber *sharedCount;
@property (copy, nonatomic, nullable) NSNumber *viewCount;
@property (copy, nonatomic, nullable) NSNumber *subscriberCount;

- (KLKSocialObject *)build;

@end

@interface KLKSocialObject (CreationWithBuilder)

+ (instancetype)socialObjectWithBuilderBlock:(void (^)(KLKSocialBuilder *socialBuilder))builderBlock;
+ (instancetype)socialObjectWithBuilder:(KLKSocialBuilder *)builder;
- (instancetype)initWithBuilder:(KLKSocialBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
