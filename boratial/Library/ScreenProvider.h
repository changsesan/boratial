//
//  ScreenProvider.h
//  neighbor
//
//  Created by Lim Sung Hoon. on 2014. 6. 11..
//  Copyright (c) 2014년 Lim Sung Hoon. All rights reserved.
//

/*!
 @brief     단말의 해상도 정보를 관리하는 공통 클래스이다.
 */
#import <Foundation/Foundation.h>

@interface ScreenProvider : NSObject
{
    BOOL isFirst;
}

+ (ScreenProvider *)sharedManager;

- (CGSize)screenSize;
- (CGFloat)screenY;
- (CGFloat)screenWidth;
- (CGFloat)screenHeight;

- (CGRect)statusBar;
- (CGFloat)statusBarHeight;

@end
