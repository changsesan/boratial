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
@class KLKLinkObject;
@class KLKButtonObject;

@class KLKLinkBuilder;

@interface KLKListTemplate : KLKTemplate

@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) KLKLinkObject *headerLink;
@property (copy, nonatomic) NSArray<KLKContentObject *> *contents;
@property (copy, nonatomic, nullable) NSArray<KLKButtonObject *> *buttons;

@end

@interface KLKListTemplate (Creation)

+ (instancetype)listTemplateWithHeaderTitle:(NSString *)headerTitle
                                 headerLink:(KLKLinkObject *)headerLink
                                   contents:(NSArray<KLKContentObject *> *)contents;
- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         headerLink:(KLKLinkObject *)headerLink
                           contents:(NSArray<KLKContentObject *> *)contents;

@end

@interface KLKListTemplateBuilder : NSObject

@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) KLKLinkObject *headerLink;
@property (copy, nonatomic) NSMutableArray<KLKContentObject *> *contents;
@property (copy, nonatomic) NSMutableArray<KLKButtonObject *> *buttons;

- (void)addContent:(KLKContentObject *)content;
- (void)addButton:(KLKButtonObject *)button;
- (KLKListTemplate *)build;

@end

@interface KLKListTemplate (CreationWithBuilder)

+ (instancetype)listTemplateWithBuilderBlock:(void (^)(KLKListTemplateBuilder *listTemplateBuilder))builderBlock;
+ (instancetype)listTemplateWithBuilder:(KLKListTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KLKListTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
