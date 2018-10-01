//
//  ScreenProvider.m
//  neighbor
//
//  Created by Lim Sung Hoon. on 2014. 6. 11..
//  Copyright (c) 2014년 Lim Sung Hoon. All rights reserved.
//

#import "ScreenProvider.h"

@implementation ScreenProvider

#pragma mark -
#pragma mark Default Manager
/*!
 @brief     싱글톤 객체를 생성한다.
 @param
 @result
 */
+ (ScreenProvider *)sharedManager
{
    static ScreenProvider *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}// MARK: 싱글톤 객체를 생성한다.


#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    if (self) {
        isFirst = YES;
    }
    return self;
}

- (CGSize)screenSize
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    /*
     if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
     {
     screenSize = [[UIScreen mainScreen] bounds].size;
     }
     else
     {
     // handling statusBar (iOS7)
     #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
     //        application.statusBarStyle = UIStatusBarStyleLightContent;
     #endif
     screenSize = [UIScreen mainScreen].applicationFrame.size;
     //        self.window.clipsToBounds = YES;
     
     //        self.navigationController.navigationBar.translucent = NO;
     }*/
    
    //    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(isFirst)
    {
        isFirst = !isFirst;
        NSLog(@"screenSize=%@", NSStringFromCGSize(screenSize));
    }
    
//    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
//    CGFloat width   = applicationFrame.size.width;
//    CGFloat height  = applicationFrame.size.height;
    return screenSize;
}

/*!
 @brief     상태바를 제외한 드로잉 가능한 시작 Y 죄표.
 @param
 @result
 */
- (CGFloat)screenY
{
    CGFloat y = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
    {
        y = 0;
    }
    else
    {
        y = [self statusBarHeight];
    }
    return y;
}// MARK: 상태바를 제외한 드로잉 가능한 시작 Y 죄표.

/*!
 @brief     세로 방향 기준에서 화면의 width.
 @param
 @result
 */
- (CGFloat)screenWidth
{
    return [self screenSize].width;
}// MARK: 세로 방향 기준에서 화면의 width.

/*!
 @brief     세로 방향 기준에서 화면의 height.
 @param
 @result
 */
- (CGFloat)screenHeight
{
    return [self screenSize].height - [self statusBarHeight];
}// MARK: 세로 방향 기준에서 화면의 height.

/*!
 @brief      상태바의 rect 정보.
 @param
 @result
 */
- (CGRect)statusBar
{
    CGRect statusBar = [[UIApplication sharedApplication] statusBarFrame];
    //    NSLog(@"statusBar=%@", NSStringFromCGRect(statusBar));
    return statusBar;
}// MARK: 상태바의 rect 정보.

/*!
 @brief      상태바의 height.
 @param
 @result
 */
- (CGFloat)statusBarHeight
{
    return MIN([self statusBar].size.width, [self statusBar].size.height);
}// MARK: 상태바의 height.

@end
