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

@class KLKLinkObject;

@interface KLKContentObject : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *imageURL;
@property (copy, nonatomic, nullable) NSNumber *imageWidth;
@property (copy, nonatomic, nullable) NSNumber *imageHeight;
@property (copy, nonatomic, nullable) NSString *desc;
@property (copy, nonatomic) KLKLinkObject *link;

@end

@interface KLKContentObject (Creation)

+ (instancetype)contentObjectWithTitle:(NSString *)title imageURL:(NSURL *)imageURL link:(KLKLinkObject *)link;
- (instancetype)initWithTitle:(NSString *)title imageURL:(NSURL *)imageURL link:(KLKLinkObject *)link;

@end

@interface KLKContentBuilder : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *imageURL;
@property (copy, nonatomic, nullable) NSNumber *imageWidth;
@property (copy, nonatomic, nullable) NSNumber *imageHeight;
@property (copy, nonatomic, nullable) NSString *desc;
@property (copy, nonatomic) KLKLinkObject *link;

- (KLKContentObject *)build;

@end

@interface KLKContentObject (CreationWithBuilder)

+ (instancetype)contentObjectWithBuilderBlock:(void (^)(KLKContentBuilder *contentBuilder))builderBlock;
+ (instancetype)contentObjectWithBuilder:(KLKContentBuilder *)builder;
- (instancetype)initWithBuilder:(KLKContentBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
