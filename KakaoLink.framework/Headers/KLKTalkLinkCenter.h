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

@class KLKTemplate;

/*!
 @typedef KLKTalkLinkSuccessHandler
 @abstract 카카오톡 링크 호출이 성공했을 경우 호출되는 완료 핸들러.
 @param warningMsg 경고 목록.<br>key: 메시지 템플릿 요소의 key path.<br>value: 경고 내용.
 @param argumentMsg templateArgs 관련 경고 목록.<br>key: templateArgs에 전달된 key 이름.<br>value: 경고 내용.
 */
typedef void(^KLKTalkLinkSuccessHandler)(NSDictionary<NSString *, NSString *> * _Nullable warningMsg, NSDictionary<NSString *, NSString *> * _Nullable argumentMsg);

/*!
 @typedef KLKTalkLinkFailureHandler
 @abstract 카카오톡 링크 호출이 도중 에러가 발생했을 경우 호출되는 완료 핸들러.
 @param error 발생한 에러.
 */
typedef void(^KLKTalkLinkFailureHandler)(NSError *error);

/*!
 @class KLKLinkCenter
 @abstract 카카오링크 API 호출을 담당하는 클래스.
 */
@interface KLKTalkLinkCenter : NSObject

/*!
 @method    sharedCenter
 @abstract  공용 KLKTalkLinkCenter 인스턴스.
 */
+ (instancetype)sharedCenter;

/*!
 @method    canOpenTalkLink
 @abstract  카카오톡 링크 실행가능 여부.
 */
- (BOOL)canOpenTalkLink;

/*!
 카카오링크 메시지의 링크로부터 실행된 액션인지 여부. 카카오링크에서 온 액션일 경우 YES.
 @param URL 앱 실행에 사용된 URL. AppDelegate의 openURL계열 메소드 파라미터 URL을 사용함.
 */
- (BOOL)isTalkLinkCallback:(NSURL *)URL;

/*!
 @method sendDefaultWithTemplate:success:failure:handledFailure:
 @abstract 기본 제공되는 템플릿을 이용하여 카카오톡 링크를 실행 함.
 @param template 전송할 메시지 템플릿 오브젝트.
 @param success 카카오링크 실행에 성공했을 때 호출 되는 완료 핸들러.
 @param failure 카카오링크 실행 중 에러가 발생했을 때 호출되는 완료 핸들러.
 @param handledFailure 카카오링크 실행 중 별도로 지정된 에러 처리 후 호출되는 완료 핸들러. 이미 SDK에 의해 에러 처리가 되었으나 UI갱신, 로깅 등 별도의 완료 처리가 필요할 경우 사용하기 위한 용도.
 */
- (void)sendDefaultWithTemplate:(KLKTemplate *)template
                        success:(nullable KLKTalkLinkSuccessHandler)success
                        failure:(nullable KLKTalkLinkFailureHandler)failure
                 handledFailure:(nullable KLKTalkLinkFailureHandler)handledFailure;

/*!
 @method sendScrapWithURL:success:failure:handledFailure:
 @abstract 지정된 URL을 스크랩하여 카카오톡 링크를 실행 함.
 @param URL 스크랩할 URL. 개발자사이트 앱 설정에 등록된 도메인만 허용됨.
 @param success 카카오링크 실행에 성공했을 때 호출 되는 완료 핸들러.
 @param failure 카카오링크 실행 중 에러가 발생했을 때 호출되는 완료 핸들러.
 @param handledFailure 카카오링크 실행 중 별도로 지정된 에러 처리 후 호출되는 완료 핸들러. 이미 SDK에 의해 에러 처리가 되었으나 UI갱신, 로깅 등 별도의 완료 처리가 필요할 경우 사용하기 위한 용도.
 */
- (void)sendScrapWithURL:(NSURL *)URL
                 success:(nullable KLKTalkLinkSuccessHandler)success
                 failure:(nullable KLKTalkLinkFailureHandler)failure
          handledFailure:(nullable KLKTalkLinkFailureHandler)handledFailure;

/*!
 @method sendScrapWithURL:success:failure:handledFailure:
 @abstract 지정된 URL을 스크랩하여 카카오톡 링크를 실행 함.
 @param URL 스크랩할 URL. 개발자사이트 앱 설정에 등록된 도메인만 허용됨.
 @param templateId 전송할 메시지 템플릿 ID
 @param templateArgs 메시지 템플릿에 필요한 추가 정보.
 @param success 카카오링크 실행에 성공했을 때 호출 되는 완료 핸들러.
 @param failure 카카오링크 실행 중 에러가 발생했을 때 호출되는 완료 핸들러.
 @param handledFailure 카카오링크 실행 중 별도로 지정된 에러 처리 후 호출되는 완료 핸들러. 이미 SDK에 의해 에러 처리가 되었으나 UI갱신, 로깅 등 별도의 완료 처리가 필요할 경우 사용하기 위한 용도.
 */
- (void)sendScrapWithURL:(NSURL *)URL
              templateId:(nullable NSString *)templateId
            templateArgs:(nullable NSDictionary<NSString *,NSString *> *)templateArgs
                 success:(nullable KLKTalkLinkSuccessHandler)success
                 failure:(nullable KLKTalkLinkFailureHandler)failure
          handledFailure:(nullable KLKTalkLinkFailureHandler)handledFailure;

/*!
 @method sendCustomWithTemplateId:templateArgs:success:failure:handledFailure:
 @abstract 지정된 메시지 템플릿을 이용하여 카카오톡 링크를 실행 함.
 @param templateId 전송할 메시지 템플릿 ID
 @param templateArgs 메시지 템플릿에 필요한 추가 정보.
 @param success 카카오링크 실행에 성공했을 때 호출 되는 완료 핸들러.
 @param failure 카카오링크 실행 중 에러가 발생했을 때 호출되는 완료 핸들러.
 @param handledFailure 카카오링크 실행 중 별도로 지정된 에러 처리 후 호출되는 완료 핸들러. 이미 SDK에 의해 에러 처리가 되었으나 UI갱신, 로깅 등 별도의 완료 처리가 필요할 경우 사용하기 위한 용도.
 */
- (void)sendCustomWithTemplateId:(NSString *)templateId
                    templateArgs:(nullable NSDictionary<NSString *,NSString *> *)templateArgs
                         success:(nullable KLKTalkLinkSuccessHandler)success
                         failure:(nullable KLKTalkLinkFailureHandler)failure
                  handledFailure:(nullable KLKTalkLinkFailureHandler)handledFailure;

@end

NS_ASSUME_NONNULL_END
