//
//  AppDelegate.m
//  neighbor
//
//  Created by SungHoonLim on 2015. 7. 7..
//  Copyright (c) 2015년 lsh. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


#define kTagPushAlert           1000
#define kTagVersionUpdate       1001

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage]
	 setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

	 [self regPushNotification];
    [NSThread sleepForTimeInterval:2.0];
    
    [self restoredCookie];
    
    
    // 어플리케이션이 실행되어있지 않은 경우 푸시를 받아서 어플리케이션이 실행될때 관련 정보가 launchOptions에 담겨오게 되며 그 정보를 가지고
    // didFinishLaunchingWithOptions를 재호출하는 로직
    // 어플리케이션 실행시 옵션 사항 중 Push 서비스 관련 정보를 추
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo != nil) {
        //[self showNotificationAlert:userInfo];
        
        self.pushLink = [[userInfo valueForKey:@"aps"] valueForKey:@"alertUrl"];
        
    }
   //  [self regPushNotification];

   
    
    //Badge 개수 설정
    application.applicationIconBadgeNumber = 0;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if(!self.mainVC) {
        self.mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
        self.window.rootViewController = rootViewController;
        
        [self.mainVC setUserAgent];
    }
    [self.window makeKeyAndVisible];
    
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:TRUE];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //[self versionCheck];
   
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveCookie];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [KOSession handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (NSString*)getPushURL
{
    return self.pushLink;
}

// 삭제
//- (NSString *)appNameAndVersionNumberDisplayString {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    return [NSString stringWithFormat:@"%@, Version %@ (%@)", appDisplayName, majorVersion, minorVersion];
//}

#pragma mark -
#pragma mark APNS Service
/**
 *	@brief APNS에 디바이스를 등록한다.
 *	@param
 *	@return
 *	@remark
 *	@see
 */
- (void)regPushNotification
{
    /*
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // ios8
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    else // ios7
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
     */
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10) { // ios10이상
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self; // 여기서 요청 아래 퍼미션
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if( !error ) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
                /// AS-IS kiko 여기서 토큰값을 요청한다.
                // required to get the app to do anything at all about push notifications
                NSLog( @"Push registration success." );
            } else {
                NSLog( @"Push registration FAILED" );
                NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
            }
        }];
    } else{
        
        // target OS 8.0 higher
        if(([[[UIDevice currentDevice] systemVersion] floatValue]) >= 8.0)
        {
            UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        /// target OS 8.0 이하일때 조건식이 필요하다
        
        ///호출시 토큰 메시지 요청처리 된다.
    }

    
}


#ifdef __IPHONE_8_0

- (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return (currentSettings.types & type);
}

#endif

- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
#ifdef __IPHONE_8_0
    // compile with Xcode 6 or higher (iOS SDK >= 8.0)
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else
    {
        if ([self checkNotificationType:UIUserNotificationTypeBadge])
        {
            NSLog(@"badge number changed to %ld", (long)badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else
            NSLog(@"access denied for UIUserNotificationTypeBadge");
    }
    
#else
    // compile with Xcode 5 (iOS SDK < 8.0)
    application.applicationIconBadgeNumber = badgeNumber;
    
#endif
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

/**
 *	@brief 어플리케이션이 최초 실행될 때에 어플리케이션이 푸시서비스를 이용함을 알리고 허용할지를 물어보게 하고 사용자의 동의를 얻었을 경우 실행되는 메서드
 *	@param
 *	@return void
 *	@remark RemoteNotification 등록 성공. deviceToken을 수신
 *	@see
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Provider에게 DeviceToken 전송
//    NSLog(@"deviceToken : %@", deviceToken);
    NSLog(@"RemoteNotification 등록 성공");
    
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
//    NSLog(@"APNS Device Token: %@", deviceId);
    // dev 32bba687dcccf00047eb53aeac35e318f3eab8636324c0886484d6ad32acd60f
    // dist
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"등록성공" message:deviceId delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [self writeToTextFile:deviceId];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceId forKey:@"UD_TOKEN_ID"];
    [defaults synchronize];
    
    
    [self.mainVC setUserAgent];
    // Token Upload
    //[self tokenUpload:deviceId];
}

// 파일 저장
//- (void)writeToTextFile:(NSString *)content
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *fileName = [NSString stringWithFormat:@"%@/token.txt", documentsDirectory];
//    [content writeToFile:fileName
//              atomically:NO
//                encoding:NSStringEncodingConversionAllowLossy
//                   error:nil];
//}

/**
 *	@brief APNS 에 RemoteNotification 등록 실패 실행되는 메서드
 *	@param
 *	@return void
 *	@remark
 *	@see
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    /*
    NSLog(@"fail RemoteNotification Registration: %@", [error description]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"APNS 등록 실패" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
     
     */
}

/**
 *	@brief 실행 중이며 Foreground/Background 푸시 메시지를 받았을 경우 호출되는 메서드.
 *	@param
 *	@return void
 *	@remark
 *	@see
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
        // ....
    }
    else
    {
        // ....
    }
    
    [self showNotificationAlert:userInfo];
}

/// kiko77
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
}

/// kiko77
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    [self showNotificationAlert:response.notification.request.content.userInfo];
    
}

- (void)showNotificationAlert:(NSDictionary *)userInfo
{
    NSLog(@"userInfo : %@", userInfo);

    
    NSString *alertMsg = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    self.pushLink = [[userInfo valueForKey:@"aps"] valueForKey:@"alertUrl"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"보라티알"
                                                   message:alertMsg
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil, nil];
    if(self.pushLink && self.pushLink.length > 0)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"보라티알"
                                          message:alertMsg
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"Go", nil];
        alert.tag = kTagPushAlert;
    }
    [alert show];
}

// 계정 qwe12345 , 1111
//#pragma mark -
//#pragma mark Token Upload
///**
// *    @brief 토큰 업로드를 요청한다.
// *    @param NSString deviceId
// *    @return void
// *    @remark
// *    @see
// */
//- (void)tokenUpload:(NSString *)deviceId
//{
//    NSString *url = [NSString stringWithFormat:@"%@%@", kUrlMain, kTokenUploadUrl];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//# if TARGET_IPHONE_SIMULATOR
//    NSLog(@"시뮬레이터에서 실행");
//    deviceId = [NSString stringWithFormat:@"32bba687dcccf00047eb53aeac35e318f3eab8636324c0886484d6ad32acd60f"];
//# else
//    NSLog(@"실제 단말에서 실행");
//    NSLog(@"deviceId = %@", deviceId);
//# endif
//
//    NSString *postParam = [NSString stringWithFormat:@"token=%@&deviceid=%@", deviceId, [UIDevice currentDevice].identifierForVendor.UUIDString];
//
//    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
////    NSLog(@"postData  = %@",postData);
//    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
//
//    [request setURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    //    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
//    [request setHTTPBody:postData];
//
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               // Our completion block code goes here
////                               NSLog(@"response = %@", response);
//
//                               NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
//                               if(urlResp.statusCode == 200){
//                                   NSLog(@"token urlResp.statusCode == 200");
//                               }
//                           }];
//}


#pragma mark -
#pragma mark CookieStorage
- (void)saveCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:@"MySavedCookies"];
}

- (void)restoredCookie
{
    //    NSLog(@"%@", @"PersisteWebCookie");
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySavedCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // push
    if (alertView.tag == kTagPushAlert){
        if(buttonIndex == 1){
            [self setApplicationBadgeNumber:0];
            
            [self.mainVC requestForURL:self.pushLink];
        }
    }
    // version update
    else if (alertView.tag == kTagVersionUpdate) {
        if(buttonIndex == 1){
            NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?mt=8", ID_APPSTORE];
            NSURL *fullUrl = [NSURL URLWithString:storeString];
            [[UIApplication sharedApplication] openURL:fullUrl];
        }
    }
}


#pragma mark - Version Check
- (void)versionCheck
{
    NSString *strClientVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#ifdef SHOW_UPDATE_ALERT
    strClientVersion = @"1.0.0";
#endif
    
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", ID_APPSTORE];
    
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) {
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    //                    int k = 10;
                }
                else {
                    NSLog(@"server = %@, client = %@", [versionsInAppStore objectAtIndex:0], strClientVersion);
        
                    NSArray *serverVersionArray = [[versionsInAppStore objectAtIndex:0] componentsSeparatedByString:@"."];
                    NSArray *clientVersionArray = [strClientVersion componentsSeparatedByString:@"."];
                    if ([serverVersionArray count] == 3 && [clientVersionArray count] == 3)
                    {
                        for (int i = 0; i < 3; i++) {
                            
                            if ([[serverVersionArray objectAtIndex:i] intValue] > [[clientVersionArray objectAtIndex:i] intValue]) {
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"보라티알" message:@"새로운 업데이트가 있습니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"다음에", @"업데이트하기", nil, nil];
                                
                                [alert setTag:kTagVersionUpdate];
                                [alert show];
                                
                                break;
                                
                            }
                            
                        }
                    }
                }
            });
        }
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
//    if ([KOSession isKakaoAccountLoginCallback:url]) {
//        return [KOSession handleOpenURL:url];
//    }
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    
    
    return FALSE;
    
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(nonnull NSURL *)url{
    if ([url.scheme isEqualToString:@"kakao9cc9897ba4ecdbfbcd4f421f72cf05bc"]) {
        NSDictionary* params = [url parseQuery];
        for (id key in params) {
            if ([key isEqualToString:@"kakao_url"]){
                NSString *stringUrl = [params objectForKey:key];
                
                if (self.mainVC != nil)
                    [self.mainVC requestForURL:stringUrl];
                else
                    self.pushLink = stringUrl;
                
            }
        }
    }
    
    return true;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    if (handled)
        return handled;
    
    return FALSE;
    
}



@end
