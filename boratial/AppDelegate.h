//
//  AppDelegate.h
//  neighbor
//
//  Created by SungHoonLim on 2015. 7. 7..
//  Copyright (c) 2015년 lsh. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController    *mainVC;
@property (strong, nonatomic) NSString              *pushLink;

@end

