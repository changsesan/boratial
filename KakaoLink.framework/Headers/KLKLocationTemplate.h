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

#import "KLKTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@class KLKContentObject;
@class KLKSocialObject;
@class KLKLinkObject;
@class KLKButtonObject;

@interface KLKLocationTemplate : KLKTemplate

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic, nullable) NSString *addressTitle;
@property (copy, nonatomic) KLKContentObject *content;
@property (copy, nonatomic, nullable) KLKSocialObject *social;
@property (copy, nonatomic, nullable) KLKButtonObject *button;

@end

@interface KLKLocationTemplate (Creation)

+ (instancetype)locationTemplateWithAddress:(NSString *)address content:(KLKContentObject *)content;
- (instancetype)initWithAddress:(NSString *)address content:(KLKContentObject *)content;

@end

@interface KLKLocationTemplateBuilder : NSObject

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic, nullable) NSString *addressTitle;
@property (copy, nonatomic) KLKContentObject *content;
@property (copy, nonatomic, nullable) KLKSocialObject *social;
@property (copy, nonatomic, nullable) KLKButtonObject *button;

- (KLKLocationTemplate *)build;

@end

@interface KLKLocationTemplate (CreationWithBuilder)

+ (instancetype)locationTemplateWithBuilderBlock:(void (^)(KLKLocationTemplateBuilder *locationTemplateBuilder))builderBlock;
+ (instancetype)locationTemplateWithBuilder:(KLKLocationTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KLKLocationTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
