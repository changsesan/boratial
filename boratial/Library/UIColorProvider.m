//
//  UIColorProvider.m
//  neighbor
//
//  Created by CreativeLab on 2014. 7. 16..
//  Copyright (c) 2014년 Lim Sung Hoon. All rights reserved.
//

#import "UIColorProvider.h"

@implementation UIColorProvider

/**
 @brief : 헥사 칼라값을 받아서 UIColor을 리턴한다.
 @data  - 2011_01_25
 @param - inColor	: color(ex:"000000", "FFFFFF")
 */
+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    UIColor *defaultResult = [UIColor blackColor];
    
    // Strip leading # if there is one
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
        componentLength = 1;
    else if ([hexValue length] == 6)
        componentLength = 2;
    else
        return defaultResult;
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}// MARK: 헥사 칼라값을 받아서 UIColor을 리턴한다.


@end
