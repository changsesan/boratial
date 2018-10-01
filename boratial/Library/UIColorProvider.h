//
//  UIColorProvider.h
//  neighbor
//
//  Created by CreativeLab on 2014. 7. 16..
//  Copyright (c) 2014년 Lim Sung Hoon. All rights reserved.
//

/*!
 @brief     UIColor 정보를 관리하는 공통 클래스이다.
 */

#import <Foundation/Foundation.h>

#define RGB(r, g, b)				[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@interface UIColorProvider : NSObject


/**
 @brief : UIColor 가져오기
 @data  - 2011_01_25
 @param - inColor	: color(ex:"000000", "FFFFFF")
 */
+ (UIColor *) colorWithHexValue:(NSString *) hexValue;

@end
