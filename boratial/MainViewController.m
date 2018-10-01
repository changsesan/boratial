//
//  MainViewController.m
//  neighbor
//
//  Created by dj jang on 2014. 11. 7..
//  Copyright (c) 2014년 dj jang. All rights reserved.
//


#define kBottomMenuHeight           0
#define kBottomBgColor              [UIColorProvider colorWithHexValue:@"31302E"]

#import "MainViewController.h"
#import "ScreenProvider.h"
//#import "IntroViewController.h"
#import "UIColorProvider.h"
#import "NSURL+Helper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/UTType.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Helper.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "UIView+Toast.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <KakaoLink/KakaoLink.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>



#import "AppDelegate.h"

enum AppStoreLinkTag {
	app_link_isp,
	app_link_bank,
}AppStoreLinkTag;

NSString* uploadType = @"";

MainViewController* controller = nil;

@interface MainViewController ()<UIWebViewDelegate>

@end

@implementation MainViewController
@synthesize bankPayUrlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    
    [self setUserAgent];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [self isApp];
    
    NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=1; i<20; i++) {
        NSString *name = [NSString stringWithFormat:@"%d", i];
        if(i<10) name = [NSString stringWithFormat:@"0%d", i];
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]];
    }
    
    self.loadingIndicatorView.animationImages = imagesArray;
    self.loadingIndicatorView.animationDuration = 1.0f;
	
    // 사이즈 스케일
    [self.webView setScalesPageToFit:YES];
	self.webView.scrollView.bounces = NO;
	self.webView.scrollView.alwaysBounceHorizontal = NO;
	self.webView.scrollView.alwaysBounceVertical = NO;
    
   // [self setUserAgent];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString* pushURL = [appDelegate getPushURL];
    
    if (pushURL != nil)
    {
        [self requestForURL:pushURL];
    }
    else
    {
        [self requestForURL:kUrlMain];
    }
    
    controller = self;
    
//    IntroViewController *intro = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
//    [self.navigationController pushViewController:intro animated:NO];

	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureRightMethod)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[_webView addGestureRecognizer:swipeRight];
	swipeRight.delegate = self;
	
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureLeftMethod)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[_webView addGestureRecognizer:swipeLeft];
	swipeLeft.delegate = self;
    
    [self startLocationStart];
    
    //[self setUserAgent];

//    UnpreventableUILongPressGestureRecognizer *lpgr = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//    lpgr.minimumPressDuration = 1.0f;
//    lpgr.allowableMovement = 100.0f;
//    lpgr.delegate = self;
//    [_webView addGestureRecognizer:lpgr];
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    NSLog(@"%@", NSStringFromCGRect(bounds));
    self.loadingIndicatorView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
//    NSLog(@"%@", NSStringFromCGPoint(_indicator.center));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLocationStart{
    NSLog(@"startLocationStart");
    
    if (nil == locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //locationManager.distanceFilter = 500;
    
    //사용중에만 위치 정보 요청
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //현재 위치 업데이트
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"%f", self.locationManager.location.coordinate.latitude);
    NSLog(@"%f", self.locationManager.location.coordinate.longitude);
    
}

//- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)recognizer
// {
//     switch ( recognizer.state )
//     {
//         case UIGestureRecognizerStateFailed:
//             // do nothing
//             break;
//
//         case UIGestureRecognizerStatePossible:
//         case UIGestureRecognizerStateCancelled:
//         {
//             NSLog(@"취소");
//             break;
//         }
//
//         case UIGestureRecognizerStateEnded:
//         {
//             NSLog(@"터치 끝");
//             break;
//         }
//
//         case UIGestureRecognizerStateBegan:
//         {
//             NSLog(@"롱터치 스타트");
//             break;
//         }
//
//         case UIGestureRecognizerStateChanged:
//         {
//             NSLog(@"드래그 부분");
//             break;
//         }
//     }
//
//     if (recognizer.state == UIGestureRecognizerStateBegan) {
//
//         CGPoint pt = [recognizer locationInView:self.webView];
//
//         // convert point from view to HTML coordinate system
//         // 뷰의 포인트 위치를 HTML 좌표계로 변경한다.
//         CGSize viewSize = [_webView frame].size;
//         CGSize windowSize = [[_webView window] frame].size;
//         CGFloat f = windowSize.width / viewSize.width;
//
//         pt.x = pt.x * f;
//         pt.y = pt.y * f;
//
//
//         [self openContextualMenuAt:pt];
//    }
//
//
//}
- (void)openContextualMenuAt{
	
	
//    NSString *tagsSRC = [self getImageUrl:pt];
//    NSString *tags = [self getHtmlTags:pt];
//
//    NSLog(@"tagsSRC : %@",tagsSRC);
//    NSLog(@"src : %@",tagsSRC);
	
	if (!_actionActionSheet) {
		_actionActionSheet = nil;
	}
	_actionActionSheet = [[UIActionSheet alloc] initWithTitle:nil
													 delegate:self
											cancelButtonTitle:nil
									   destructiveButtonTitle:nil
											otherButtonTitles:nil];
	

		
	[_actionActionSheet addButtonWithTitle:@"앨범에서 불러오기"];
    [_actionActionSheet addButtonWithTitle:@"카메라 찍기"];
    [_actionActionSheet addButtonWithTitle:@"취소"];
    _actionActionSheet.cancelButtonIndex = (_actionActionSheet.numberOfButtons-1);
    [_actionActionSheet showInView:_webView];

	
}
- (NSString *) getHtmlTags:(CGPoint) point {
	
	
	NSString *js = [NSString stringWithFormat:@"tagparsing.getHTMLElementsAtPoint(%d,%d)", (int)point.x , (int)point.y];
	NSLog(@"webViewDidFinishLoad %@", [_webView stringByEvaluatingJavaScriptFromString:js]);
	
	return [_webView stringByEvaluatingJavaScriptFromString:js];
}
- (NSString *) getImageUrl:(CGPoint) point {

	
	NSString *js = [NSString stringWithFormat:@"srcparsing.getLinkSRCAtPoint(%d,%d)", (int)point.x , (int)point.y];
	NSLog(@"webViewDidFinishLoad %@", [_webView stringByEvaluatingJavaScriptFromString:js]);
	
	return [_webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"앨범에서 불러오기"]){
		[self uploadImage];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"카메라 찍기"]){
        [self captureImage];
    }
}

-(void)saveImageURL:(NSString*)url{
	[self performSelectorOnMainThread:@selector(showStartSaveAlert)
						   withObject:nil
						waitUntilDone:YES];
	
	UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
	
	[self performSelectorOnMainThread:@selector(showFinishedSaveAlert)
						   withObject:nil
						waitUntilDone:YES];
}

-(void) showStartSaveAlert {
	[self.loadingIndicatorView startAnimating];
}

-(void) showFinishedSaveAlert {
	[self.loadingIndicatorView stopAnimating];
}

- (void) handleSwipeGestureRightMethod {
	
	[_webView goBack];
	NSLog(@"handleSwipeGestureRightMethod");
}

- (void) handleSwipeGestureLeftMethod {
	
	[_webView goForward];
	NSLog(@"handleSwipeGestureLeftMethod");
}

#pragma mark - private method
- (void)requestForURL:(NSString *)textUrl
{
    NSURL *url = [NSURL URLWithString:textUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	NSLog(@"webViewDidStartLoad:webView");
//    [_indicator startAnimating];
    [self.loadingIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"webViewDidFinishLoad:webView");
//    [_indicator stopAnimating];
    [self.loadingIndicatorView stopAnimating];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    /*
    NSString *js = [NSString stringWithFormat:@"var pushnpush; pushnpush = { getPushToken: function() { return 'v%@'; } , getVersion: function() { return 'v%@'; }, getDeviceid: function() { return '%@'; }, getOS: function() { return 'iOS';} }; $('#versionmsg').html(pushnpush.getVersion());", @"1213231231",majorVersion, deviceid];
	[self.webView stringByEvaluatingJavaScriptFromString:js];
	
	NSString *imageSrcPargingJS = [NSString stringWithFormat:@"var srcparsing; srcparsing = { getLinkSRCAtPoint: function(x,y) { var tags = ''; var e = document.elementFromPoint(x,y); while(e) { if (e.src) { tags += e.src ; break ; }  e = e.parentNode; } return tags; } };"];
	[self.webView stringByEvaluatingJavaScriptFromString:imageSrcPargingJS];
	
	NSString *tagsPargingJS = [NSString stringWithFormat:@"var tagparsing; tagparsing = { getHTMLElementsAtPoint: function(x,y) { var tags = ''; var e = document.elementFromPoint(x,y); while(e) { if (e.tagName) { tags += e.tagName ; break ; }  e = e.parentNode; } return tags; } };"];
	[self.webView stringByEvaluatingJavaScriptFromString:tagsPargingJS];
	*/
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"webView:didFailLoadWithError");
//    [_indicator stopAnimating];
    [self.loadingIndicatorView stopAnimating];
}

- (void) requestBankPayResult:(NSString*)bodyString
{
	//bankPayUrlString 계좌이체 인증 결과 url
	
	NSURL *url = [NSURL URLWithString: [bankPayUrlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"BANK URL: %@", url);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [bodyString dataUsingEncoding: NSUTF8StringEncoding]];
	[_webView loadRequest: request];
}

- (void) requesIspPayResult:(NSString*)urlString
{
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
	[request setHTTPMethod: @"GET"];
	[_webView loadRequest: request];
	
}



#pragma mark UIWebViewDelegate
/*
 카드결제 ISP 인증, 금결원 계좌이체 앱을 호출 하기 예외처리가 되는 부분 입니다.
 이 함수를 구현하지 않을 경우 ISP 와 계좌이체 서비스를 이용 하실 수 없습니다.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	//현재 URL 을 읽음
	NSString* URLString = [NSString stringWithString:[request.URL absoluteString]];
	
	NSLog(@"current URL %@",URLString);
    
    NSLog(@"request.URL.host = %@", request.URL.host);
    if ([URLString hasPrefix:@"about:blank"])
        return NO;
    
    
    NSString *reqUrl2 = [[request URL] absoluteString];
    NSLog(@"webview에 요청된 URL => %@", reqUrl2);
    /*
    if ([reqUrl2 containsString:@"dongafblogin"]){
        
        [self checkWithFacebook];
    }
    else if([request.URL.host containsString:@"dongafblogin"])
    {
         [self checkWithFacebook];
    }
    else if ([URLString containsString:@"dongafblogin"])
    {
         [self checkWithFacebook];
    }
     */
    /*
    else if([request.URL.host isEqualToString:@"m.facebook.com"])
    {
        [self checkWithFacebook];
    }
     */

    
    if ([URLString hasPrefix:@"boratial"])
    {
        NSDictionary *query = [request.URL parseQuery];
        uploadType = [query objectForKey: @"f"];
        
        //이미지 업로드
        if ([request.URL.host isEqualToString:@"uploadimage"]) {
            //[self uploadImage];
            [self openContextualMenuAt];
            
            return NO;
        }
        else if ([request.URL.host isEqualToString:@"location"]) {
            
            NSString *strJob = [query objectForKey: @"job"];
            NSString *script = [NSString stringWithFormat:@"location_return('%f','%f','%@');",  self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, strJob];
            NSLog(script);
            [self.webView stringByEvaluatingJavaScriptFromString:script];
            return NO;
        }
        else if ([request.URL.host isEqualToString:@"sharekakao"]) {
            NSDictionary* params = [request.URL parseQuery];
            
            NSString* strShareURL;
            NSString* strTitile;
            NSString* strImgUrl;
            for (id key in params) {
                if ([key isEqualToString:@"share_url"]){
                    strShareURL = [params objectForKey:key];
                }
                else if ([key isEqualToString:@"share_title"]){
                    NSString* strTitileTemp = [params objectForKey:key];
                    
                    //NSUTF8StringEncoding dㅣ 인코딩으로 한글 변환이 안되는 경우가 생겨 한번더 인코딩 하고 그래도 안되면 빈 문자열을 보낸다.
                    strTitile = [strTitileTemp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    if (strTitile == nil)
                        strTitile = [strTitileTemp stringByReplacingPercentEscapesUsingEncoding:0x80000940];
                    
                    if (strTitile == nil)
                        strTitile = @"";
                    
                    
                    
                }
                else if ([key isEqualToString:@"share_img"]){
                    strImgUrl = [params objectForKey:key];
                }
            }
            
            [self OnShareByKakao:strShareURL
                       strTitle : strTitile
                      strImgUrl : strImgUrl];
            
            return NO;
        }
        else if ([request.URL.host isEqualToString:@"sharefacebook"]) {
            NSDictionary* params = [request.URL parseQuery];
            
            NSString* strShareURL;
            NSString* strTitile;
            NSString* strImgUrl;
            for (id key in params) {
                if ([key isEqualToString:@"share_url"]){
                    strShareURL = [params objectForKey:key];
                }
                else if ([key isEqualToString:@"share_title"]){
                    NSString* strTitileTemp = [params objectForKey:key];
                    
                    //NSUTF8StringEncoding dㅣ 인코딩으로 한글 변환이 안되는 경우가 생겨 한번더 인코딩 하고 그래도 안되면 빈 문자열을 보낸다.
                    strTitile = [strTitileTemp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    if (strTitile == nil)
                        strTitile = [strTitileTemp stringByReplacingPercentEscapesUsingEncoding:0x80000940];
                    
                    if (strTitile == nil)
                        strTitile = @"";
                    
                    
                    
                }
                else if ([key isEqualToString:@"share_img"]){
                    strImgUrl = [params objectForKey:key];
                }
            }
            
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:strShareURL];
            
            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
            dialog.fromViewController = self;
            dialog.shareContent = content;
            dialog.mode = FBSDKShareDialogModeFeedWeb;
            [dialog show];
            
            return NO;
        }

    }
    
    
	
	//app store URL 여부 확인
	BOOL goAppStore =  ([URLString rangeOfString:@"phobos.apple.com" options:NSCaseInsensitiveSearch].location != NSNotFound);
	BOOL goAppStore2 =  ([URLString rangeOfString:@"itunes.apple.com" options:NSCaseInsensitiveSearch].location != NSNotFound);
	
	//app store 로 연결하는 경우 앱스토어 APP을 열어 준다. (isp, bank app 이 설치하고자 경우)
	if(goAppStore || goAppStore2){
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
    
    UIDevice* device = [UIDevice currentDevice];
    
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    NSLog(@"backgroundSupported ==>%@",(backgroundSupported?@"YES":@"NO"));
    if (!backgroundSupported){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"안 내"
                                                      message:@"멀티테스킹을 지원하는 기기 또는 어플만  공인인증서비스가 가능합니다."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return YES;
    }
	
    NSString *reqUrl = [[request URL] absoluteString];
    NSLog(@"webview에 요청된 URL => %@", reqUrl);
    
    if ([reqUrl hasPrefix:@"dongafblogin://"]){
        [self loginWithFacebook];
         //[self checkWithFacebook];
    }
    if ([reqUrl hasPrefix:@"ispmobile://"]){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ispmobile://"]]) {
            // ISPMobile 호출
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"확인버튼을 누르시면 스토어로 이동합니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            [alert setTag:1];
            [alert show];
            return NO;
        }
    }
    if ([reqUrl hasPrefix:@"smartxpay-transfer://"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartxpay-transfer://"]]) {
            // smartxpay 호출
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"설치하시겠습니까?" message:@"확인버튼을 누르시면 스토어로 이동합니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            [alert setTag:2];
            [alert show];
            return NO;
        }
    }
    //스마트 신한앱 다운로드 url
    NSString  *sh_url = @"http://itunes.apple.com/us/app/id360681882?mt=8";
    //신한Mobile앱 결제 다운로드 url
    NSString  *sh_url2= @"https://itunes.apple.com/kr/app/sinhan-mobilegyeolje/id572462317?mt=8";
    //현대 다운로드 url
    NSString  *hd_url = @"http://itunes.apple.com/kr/app/id362811160?mt=8";
    //스마트 신한 url 스키마
    NSString  *sh_appname = @"smshinhanansimclick";
    //스마트 신한앱 url 스키마
    NSString  *sh_appname2 = @"shinhan-sr-ansimclick";
    //현대카드 url
    NSString  *hd_appname = @"smhyundaiansimclick";
    /// kiko 추가
    //롯데카드 url
    NSString  *lottecard = @"lottesmartpay";
    
    if ([reqUrl isEqualToString:hd_url] == YES ){
        NSLog(@"1. 현대 관련 url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ( [reqUrl hasPrefix:hd_appname]){
        NSLog(@"2. 현대 관련 url 입니다.==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ([reqUrl isEqualToString:sh_url] == YES ){
        NSLog(@"1. 스마트신한 관련 url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ( [reqUrl hasPrefix:sh_appname]){
        NSLog(@"2. 스마트신한 관련 url 입니다.==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ([reqUrl isEqualToString:sh_url2] == YES ){
        NSLog(@"1. 스마트신한앱 관련 url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ( [reqUrl hasPrefix:sh_appname2]){
        NSLog(@"2. 신한모바일앱 관련 url 입니다.==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ( [reqUrl hasPrefix:lottecard]){
        NSLog(@"롯데카드 url 입니다.==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    //NH카드 공인인증서  다운로드 url
    NSString  *nh_url = @"https://itunes.apple.com/kr/app/nhansimkeullig/id609410702?mt=8";
    //nh카드 앱 url 스키마
    NSString  *nh_appname = @"nonghyupcardansimclick";
    if ([reqUrl isEqualToString:nh_url] == YES ){
        NSLog(@"NH앱 관련 url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if ( [reqUrl hasPrefix:nh_appname]){
        NSLog(@"NH 앱 관련 url 입니다.==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    
    if (![reqUrl hasPrefix:@"http://"] && ![reqUrl hasPrefix:@"https://"]){
        NSLog(@"  앱  url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
    }else{
        NSLog(@"  앱  url 입니다. ==>%@",reqUrl);
    }
    
    /// kiko END
    NSLog(@"webview에 요청된 url==>%@",reqUrl);
    
    if ([reqUrl rangeOfString:@"http://itunes.apple.com"].location !=NSNotFound) {
        NSLog(@"1.  앱설치  url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
        
    if ([reqUrl rangeOfString:@"ansimclick"].location !=NSNotFound) {
        NSLog(@"  앱  url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
            
    if ([reqUrl rangeOfString:@"appfree"].location !=NSNotFound) {
        NSLog(@"  앱  url 입니다. ==>%@",reqUrl);
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
//    NSRange strRange = [URLString rangeOfString:@"kakao.com"];
//    if(strRange.location != NSNotFound){
//        [[UIApplication sharedApplication] openURL:request.URL];
//        return YES;
//    }

	
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
//    [dic objectForKey:@""];
	
	return YES;
}

-(void)loginWithKakao{
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            // login success
            NSLog(@"login succeeded.");
            
            [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
                if (result) {
                    // success
                    NSLog(@"userId=%@", result.ID);
                    NSLog(@"nickName=%@", [result propertyForKey:KOUserNicknamePropertyKey]);
                    NSLog(@"userId=%@", result.email);
                    
                    NSString *script = [NSString stringWithFormat:@"loginWithKakaoResult('%@','%@')", result.email, [result propertyForKey:KOUserNicknamePropertyKey]];
                    [self.webView stringByEvaluatingJavaScriptFromString:script];

                } else {
                    // failed
                }
            }];
        } else {
            // failed
            NSLog(@"login failed.");
        }
    }authType:(KOAuthType)KOAuthTypeAccount, nil];
}

-(void)checkWithKakao{
    [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
        if (error) {
            NSString *script = [NSString stringWithFormat:@"checkWithKakaoResult('N')"];
            [self.webView stringByEvaluatingJavaScriptFromString:script];
        } else {
            NSLog(@"남은 유효시간: %@ (단위: ms)", accessTokenInfo.expiresInMillis);
            
            [self loginWithKakao];
        }
    }];
}

-(void)loginWithFacebook{
    if ([FBSDKAccessToken currentAccessToken]){
        [self fetchUserInfoWithFacebook];
    }
    else {
        //한번도 로그인 하지 않은 사용자
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error){
                NSLog(@"Process error");
            }
            else if (result.isCancelled){
                NSLog(@"Cancelled");
            }
            else {
                NSLog(@"Logged in");
                [self fetchUserInfoWithFacebook];
            }
        }];
    }
}

-(void)checkWithFacebook{
    
    FBSDKAccessToken* AccessToken = [FBSDKAccessToken currentAccessToken];
    
    NSString *tokenString = AccessToken.tokenString;
    
    if ([FBSDKAccessToken currentAccessToken]){
        [self fetchUserInfoWithFacebook];
    }
    else {
        NSString *script = [NSString stringWithFormat:@"checkWithFacebookResult('N')"];
        [self.webView stringByEvaluatingJavaScriptFromString:script];
    }
}

-(void)fetchUserInfoWithFacebook{
//    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
//    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
//    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        if (result)
//        {
//            NSLog(@"userId=%@", [result objectForKey:@"id"]);
//            NSLog(@"nickName=%@", [result objectForKey:@"name"]);
//
//            NSString *script = [NSString stringWithFormat:@"loginWithFacebookResult('%@','%@')", [result objectForKey:@"id"], [result objectForKey:@"name"]];
//            [self.webView stringByEvaluatingJavaScriptFromString:script];
//        }
//    }];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"userId=%@", [result objectForKey:@"id"]);
             NSLog(@"nickName=%@", [result objectForKey:@"name"]);
             NSLog(@"email=%@", [result objectForKey:@"email"]);
             
             NSString *script = [NSString stringWithFormat:@"loginWithFacebookResult('%@','%@')", [result objectForKey:@"email"], [result objectForKey:@"name"]];
             [self.webView stringByEvaluatingJavaScriptFromString:script];
         }
     }];
}

-(void)uploadImage{
    //이미지 선택
    self.imageController = [[UIImagePickerController alloc] init];
    self.imageController.delegate = self;
    self.imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imageController animated:YES completion:NULL];
}

-(void)captureImage{
    // 카메라가 이용 가능한지 확인
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 인스턴스 생성
        self.imageController = [[UIImagePickerController alloc] init];
        
        // 이미지 소스에 카메라를 지정
        self.imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 촬영 후에 편집 불가능
        self.imageController.allowsEditing = NO;
        
        // 델리게이트를 이 클래스에 지정
        self.imageController.delegate = self;
        
        // 시작
        [self presentViewController:self.imageController animated:YES completion:nil];
    }
}

- (void)uploadVideoFile {
    // Collect the metadata for the upload from the user interface.
    
    //동영상 선택
    self.imageController = [[UIImagePickerController alloc] init];
    self.imageController.delegate = self;
    self.imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imageController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:self.imageController animated:YES completion:NULL];
    
}

- (void)requestPostUrlWithImage:(UIImage *)image
                      imageName:(NSString *)imageName {
    
    [MBProgressHUD showHUDAddedTo:self.imageController.view animated:YES];
    
    NSString *serviceUrl = IMG_UPLOAD_URL;
    
    NSData *fileData = image ? UIImageJPEGRepresentation(image, 1.0f) : nil;
    
    if (imageName == nil)
        imageName = @"captureImage.jpg";
    
    NSError *error;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:serviceUrl
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        if (fileData) {
                                            [formData appendPartWithFileData:fileData
                                                                        name:@"file1"
                                                                    fileName:imageName
                                                                    mimeType:@"multipart/form-data"];
                                            
                                            [formData appendPartWithFormData:[uploadType dataUsingEncoding:NSUTF8StringEncoding]
                                                                        name:@"f"];
                                        }
                                    } error:&error];
    
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress *uploadProgress) {
                                              //DDLogDebug(@"Wrote %f", uploadProgress.fractionCompleted);
                                          }
                                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                              if (error) {
                                                  [controller.view makeToast:@"서버의 응답정보가 올바르지 않습니다."];
                                              }
                                              else {
                                                  NSString *result_data = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
               
                                                  if (![result_data isEqualToString:@""]){
                                
                                                      NSString *script = [NSString stringWithFormat:@"mobile_upload_return('%@','%@');", uploadType, result_data];
                                                      [self.webView stringByEvaluatingJavaScriptFromString:script];
                                                      [self.view makeToast:@"업로드 성공"];
                                                  }
                                              }
                                              [MBProgressHUD hideHUDForView:self.imageController.view animated:YES];
                                              [self.imageController dismissViewControllerAnimated:NO completion:nil];
                                              
                                          }];
    [uploadTask resume];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"imagePickerController");
    NSString *type = [info objectForKey: UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset) {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            [self requestPostUrlWithImage:[image fixOrientation] imageName:[imageRep filename]];
        };
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:[info valueForKey:UIImagePickerControllerReferenceURL]
                       resultBlock:resultblock
                      failureBlock:nil];
        
    }
    else{
        NSURL *movieURL = [info objectForKey: UIImagePickerControllerMediaURL];
        
        NSURL *fileToUploadURL = [NSURL fileURLWithPath:[movieURL path]];
        
        NSString *filename = [fileToUploadURL lastPathComponent];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset) {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            [self requestPostUrlWithMov:movieURL imageName:filename];
        };
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:[info valueForKey:UIImagePickerControllerMediaURL]
                       resultBlock:resultblock
                      failureBlock:nil];
        
    }
    
}

- (void)requestPostUrlWithMov:(NSURL *)movieURL
                      imageName:(NSString *)imageName {
    
    [MBProgressHUD showHUDAddedTo:self.imageController.view animated:YES];
    
    NSString *serviceUrl = IMG_UPLOAD_URL;
    
    NSData *fileData = [NSData dataWithContentsOfURL:movieURL];
    
    if (fileData.length > 30 * 1024 * 1024)
    {
        [self.view makeToast:@"30MB 이하의 파일만 업로드 가능합니다."];
        [MBProgressHUD hideHUDForView:self.imageController.view animated:YES];
    }
    
    NSError *error;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:serviceUrl
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        if (fileData) {
                                            [formData appendPartWithFileData:fileData
                                                                        name:@"file1"
                                                                    fileName:imageName
                                                                    mimeType:@"multipart/form-data"];
                                        }
                                    } error:&error];
    
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress *uploadProgress) {
                                              //DDLogDebug(@"Wrote %f", uploadProgress.fractionCompleted);
                                          }
                                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                              if (error) {
                                                  [controller.view makeToast:@"서버의 응답정보가 올바르지 않습니다."];
                                              }
                                              else {
                                                  NSString *result_data = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
                                                  
                                                  if (![result_data isEqualToString:@""]){
                                                      
                                                      NSString *script = [NSString stringWithFormat:@"mobile_upload_return('%@','%@');", uploadType, result_data];
                                                      [self.webView stringByEvaluatingJavaScriptFromString:script];
                                                      [self.view makeToast:@"업로드 성공"];
                                                  }
                                              }
                                              [MBProgressHUD hideHUDForView:self.imageController.view animated:YES];
                                              [self.imageController dismissViewControllerAnimated:NO completion:nil];
                                              
                                          }];
    [uploadTask resume];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker
{
    NSLog(@"dismiss image picker");
    [self.imageController dismissViewControllerAnimated:NO completion:nil];
    // And every other way i could think of
}




- (void) showAlertViewWithMessage:(NSString*)msg tagNum:(NSInteger)tag
{
	
	UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"알림"
												message:msg
											   delegate:self
									  cancelButtonTitle:@"확인"
									  otherButtonTitles:nil];
	
	v.tag = tag;
	
	[v show];
}


#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == app_link_isp)
	{
		NSString* URLString = @"http://itunes.apple.com/kr/app/id369125087?mt=8";
		NSURL* storeURL = [NSURL URLWithString:URLString];
		[[UIApplication sharedApplication] openURL:storeURL];
	}
	else if(alertView.tag == app_link_bank)
	{
		NSString* URLString = @"http://itunes.apple.com/us/app/id398456030?mt=8";
		NSURL* storeURL = [NSURL URLWithString:URLString];
		[[UIApplication sharedApplication] openURL:storeURL];
		
	}
}


/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request url : %@", [request URL]);
	
    if(![self webViewRequestProcess:request]) return NO;
 
    self.language = [self getCookiesLanguage];
    NSLog(@"self.language : [%@]", self.language);
 
	return TRUE;
}*/

- (BOOL)webViewRequestProcess:(NSURLRequest *)request
{
    NSString *requestStr = [[request URL] absoluteString];
//    self.reqUrlString = requestStr;
    DLog(@"requestStr:%@", requestStr);
    
    if ([[[request URL] absoluteString] hasPrefix:@"jscallback://?"])
    {
        NSString *protocolPrefix = @"jscallback://?";
        NSString *urlStr = [[request URL] absoluteString];
        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"urlStr = %@",urlStr);
        NSError *jsonError;
        NSDictionary *callInfo = [NSJSONSerialization
                                  JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
                                  options:kNilOptions
                                  error:&jsonError];
        NSLog(@"callInfo = %@",callInfo);
        
        if (jsonError != nil)
        {
            //call error callback function here
            NSLog(@"Error parsing JSON for the url %@",requestStr);
            return NO;
        }
        
        
        NSString *functionName = [callInfo objectForKey:@"functionname"];
        if (functionName == nil)
        {
            NSLog(@"Missing function name");
            return NO;
        }
        
        NSString *successCallback = [callInfo objectForKey:@"success"];
        NSString *errorCallback = [callInfo objectForKey:@"error"];
        NSArray *argsArray = [callInfo objectForKey:@"args"];
        [self callFunction:functionName withArgs:argsArray onSuccess:successCallback onError:errorCallback];
        
        return NO;
    }
    return YES;
}

- (void)setUserAgent
{
    UIWebView* webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"userAgent\t%@", userAgent);
    if (userAgent == nil || [userAgent isEqualToString:@""] )
    {
        userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Mobile;",
                               [[UIDevice currentDevice] model],                                                            //모델(iPhone, iPad)
                               [[UIDevice currentDevice] model],                                                            //모델(iPhone, iPad)
                               [[UIDevice currentDevice] model]                                                             //모델(iPhone, iPad)
                               ];
    }

    NSString *uuID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pushToken = [defaults stringForKey:@"UD_TOKEN_ID"];
    
    UIDevice *device = [UIDevice currentDevice];
    /*
    let userAgent = mWebview.stringByEvaluatingJavaScript(from: "navigator.userAgent")
    
    let setAgent = "\(String(describing: userAgent!));HTTP_USER_AGENT=\(_GA.getAppBundleID()!);uuid=\(self.UUID());os=ios;appVersion=\(_GA.getAppVersion()!);pushToken=\(String(describing: myToken))"
    UserDefaults.standard.register(defaults: ["UserAgent" : setAgent])
    print(">>> user agent setting value >>> \(setAgent)")
    */
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *customUserAgent = [NSString stringWithFormat:@"HTTP_USER_AGENT=%@;os=ios;uuid=%@;appversion=%@;pushtoken=%@;",bundleId, uuID, appVersion, pushToken];
    //NSString *customUserAgent = [NSString stringWithFormat:@"os=%@;uuid=%@;appversion=%@;pushToken=%@;", device.model, uuID, appVersion, pushToken];
    NSLog(@"customUserAgent\t%@", customUserAgent);
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@;%@", userAgent, customUserAgent], @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    NSString *userAgent2 = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"userAgent 222222222222\t%@", userAgent2);
    
}


-(void)OnShareByKakao:(NSString*)url strTitle:(NSString*)strTitle strImgUrl:(NSString*)strImgUrl{
    // 스크랩할 웹페이지 URL
    NSURL *URL = [NSURL URLWithString:url];
    
    KLKTemplate *template = [KLKFeedTemplate feedTemplateWithBuilderBlock:^(KLKFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        // 컨텐츠
        feedTemplateBuilder.content = [KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = strTitle;
            contentBuilder.imageURL = [NSURL URLWithString:strImgUrl];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:url];
            }];
        }];
        
        
        // 버튼
        [feedTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 이동";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = [NSString stringWithFormat:@"kakao_url=%@",url];
                linkBuilder.androidExecutionParams = [NSString stringWithFormat:@"kakao_url=%@",url];
            }];
        }]];
    }];
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
    } failure:^(NSError * _Nonnull error) {
        
        
    } handledFailure:^(NSError * _Nonnull error) {
       
        
    }];
    
    
}


/*
#pragma mark -
#pragma mark  Rotation IOS6 이상
- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
    //    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self deviceOrientationChanged];
}

- (void)deviceOrientationChanged
{
//    CGFloat screenY         = [[ScreenProvider sharedManager] screenY];
    CGFloat screenWidth     = [[ScreenProvider sharedManager] screenWidth];
    CGFloat screenHeight    = [[ScreenProvider sharedManager] screenHeight];
    CGFloat statusBarHeight = [[ScreenProvider sharedManager] statusBarHeight];
    
//    CGRect rect = CGRectMake(0, screenY, screenWidth, screenHeight);
//    NSLog(@"rect = %@", NSStringFromCGRect(rect));
    UIDeviceOrientation o = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsPortrait(o))
    {
        self.webView.frame = CGRectMake(0, statusBarHeight, screenWidth, screenHeight-kBottomMenuHeight);
//        self.mapView.frame = self.webView.frame;
        
//        self.webView.frame = CGRectMake(0, statusBarHeight, screenWidth, screenHeight);
    }
    else
    {
        self.webView.frame = CGRectMake(0, statusBarHeight, screenWidth, screenHeight-kBottomMenuHeight-statusBarHeight);
//        self.mapView.frame = self.webView.frame;
    }
    
    NSLog(@"webView = %@", NSStringFromCGRect(self.webView.frame));
    NSLog(@"Menu Hide +============>>>> ");
}*/


#pragma mark -
#pragma mark Bottom Action
///**
// *	@brief 하단 메뉴 클릭시 이벤트를 처리한다.
// *	@param
// *	@return
// *	@remark
// *	@see
// */
//- (void)clickButtonMenu:(id)sender
//{
//    if(sender == self.btnBottom1)
//    {
//        if(self.mapView.hidden == NO)
//        {
//            [self.mapView setHidden:YES];
//            return;
//        }
//        if ([self.webView canGoBack]) {
//            [self.webView goBack];
//        }
//    }
//    else if(sender == self.btnBottom2)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[self phoneNumber:kCallNumber] delegate:self cancelButtonTitle:nil otherButtonTitles:@"취소", @"통화", nil, nil];
//        if([self.language isEqualToString:@"ENG"]) alert = [[UIAlertView alloc] initWithTitle:nil message:[self phoneNumber:kNationalCallNumber] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", @"Call", nil, nil];
//        [alert setTag:1234];
//        [alert show];
//        
//    }
//    else if(sender == self.btnBottom3)
//    {
//        [self updatePointAnnotation];
//        
//        // google map
//        [self.mapView setHidden:NO];
//    }
//    else if(sender == self.btnBottom4)
//    {
//        if(self.mapView.hidden == NO)
//        {
//            [self.mapView setHidden:YES];
//        }
//        
//        // setting
//        [self requestForURL:@"http://www.nesthotel.co.kr/include/setting.asp?ver=3"];
////        [self requestForURL:@"http://nesthotel.co.kr/app/counsel_app.html"];
//    }
//}


#pragma mark -
#pragma mark JavaScript CallBack Function
- (void)callFunction:(NSString *)name withArgs:(NSArray *)args onSuccess:(NSString *)successCallback onError:(NSString *)errorCallback
{
    NSError *error;
    id retVal = nil;
//    if([name isEqualToString:@"getToken"]) retVal = [[JsonProvider sharedManager] makeJsonStringByTokenId];
//    else if([name isEqualToString:@"getAppVersion"]) retVal = [[JsonProvider sharedManager] makeJsonStringByAppVersion];
    
    if (error != nil)
    {
        NSString *resultStr = [NSString stringWithString:error.localizedDescription];
        [self callErrorCallback:errorCallback withMessage:resultStr];
        return;
    }
    
    [self callSuccessCallback:successCallback withRetValue:retVal forFunction:name];
}

- (void)callErrorCallback:(NSString *)name withMessage:(NSString *)msg
{
    if (name != nil)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",name,msg]];
    }
    else
    {
        NSLog(@"%@",msg);
    }
}

- (void)callSuccessCallback:(NSString *)name withRetValue:(id)retValue forFunction:(NSString *)funcName
{
    if (name != nil)
    {
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        [resultDict setObject:retValue forKey:@"result"];
        [self callJSFunction:name withArgs:resultDict];
    }
    else
    {
        NSLog(@"Result of function %@ = %@", funcName,retValue);
    }
}

- (void)callJSFunction:(NSString *)name withArgs:(NSMutableDictionary *)args
{
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&jsonError];
    if (jsonError != nil)
    {
        //call error callback function here
        NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
        return;
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@", jsonStr);
    
    if (jsonStr == nil)
    {
        NSLog(@"jsonStr is null. count = %d", (int)[args count]);
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",name,jsonStr]];
}


#pragma mark -
#pragma mark Cookies

- (NSString *)urlencode:(NSString *)ori
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[ori UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

//- (NSString *)getCookiesLoginUserName
//{
//    NSString *value = @"";
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [cookieJar cookies]) {
//        NSString *cookieName = [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        if([cookieName isEqualToString:@"CookieForMobile_name"])
//        {
//            value = [[cookie value] stringByReplacingPercentEscapesUsingEncoding:-2147481280];
//            break;
//        }
//    }
//    NSLog(@"LoginUserName : %@", value);
//    return value;
//}

- (NSString *)getCookiesLanguage
{
    NSString *value = @"";
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSString *cookieName = [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([cookieName isEqualToString:@"CookieForMobile_lang"])
        {
            value = [[cookie value] stringByReplacingPercentEscapesUsingEncoding:-2147481280];
            break;
        }
    }
    NSLog(@"getCookiesLanguage : %@", value);
    return value;
}

- (void)dumpCookies:(NSString *)msgOrNil
{
    NSMutableString *cookieDescs = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        [cookieDescs appendString:[self cookieDescription:cookie]];
    }
    NSLog(@"------ [Cookie Dump: %@] ---------\n%@", msgOrNil, cookieDescs);
    NSLog(@"----------------------------------");
}

- (NSString *)cookieDescription:(NSHTTPCookie *)cookie
{
    NSMutableString *cDesc      = [[NSMutableString alloc] init];
    [cDesc appendString:@"[NSHTTPCookie]\n"];
    [cDesc appendFormat:@"  name            = %@\n",            [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //    [cDesc appendFormat:@"  value1           = %@\n",            [[cookie value] stringByReplacingPercentEscapesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean]];
    [cDesc appendFormat:@"  value           = %@\n",            [[cookie value] stringByReplacingPercentEscapesUsingEncoding:-2147481280]];
    [cDesc appendFormat:@"  domain          = %@\n",            [cookie domain]];
    [cDesc appendFormat:@"  path            = %@\n",            [cookie path]];
    [cDesc appendFormat:@"  expiresDate     = %@\n",            [cookie expiresDate]];
    [cDesc appendFormat:@"  sessionOnly     = %d\n",            [cookie isSessionOnly]];
    [cDesc appendFormat:@"  secure          = %d\n",            [cookie isSecure]];
    [cDesc appendFormat:@"  comment         = %@\n",            [cookie comment]];
    [cDesc appendFormat:@"  commentURL      = %@\n",            [cookie commentURL]];
    [cDesc appendFormat:@"  version         = %lu\n",            (unsigned long)[cookie version]];
    
    //  [cDesc appendFormat:@"  portList        = %@\n",            [cookie portList]];
    //  [cDesc appendFormat:@"  properties      = %@\n",            [cookie properties]];
    
    return cDesc;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
   // NSLog(@"%@", [locations lastObject]);
}


#pragma mark -
#pragma mark  IsApp
- (void)isApp
{
    NSString *url = [NSString stringWithFormat:@"%@", kUrlMain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // Our completion block code goes here
//                               NSLog(@"response = %@", response);

                               NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
                               if(urlResp.statusCode == 200){
//                                   NSLog(@"isapp urlResp.statusCode == 200");
                               }
                           }];
}


#pragma mark -
#pragma mark UIAlertView Delegate


@end


@implementation UnpreventableUILongPressGestureRecognizer

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
	return NO;
}

@end
