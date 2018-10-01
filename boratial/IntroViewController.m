//
//  IntroViewController.m
//  ShoeMarker
//
//  Created by dj jang on 2014. 11. 7..
//  Copyright (c) 2014년 dj jang. All rights reserved.
//

#import "IntroViewController.h"
#import "MainViewController.h"
#import "ScreenProvider.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

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
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
    if (!self.bgImage) {
        self.bgImage = [[FLAnimatedImageView alloc] init];
        self.bgImage.frame = CGRectMake(0.0, 0.0, [[ScreenProvider sharedManager] screenWidth], [[ScreenProvider sharedManager] screenSize].height);
        self.bgImage.contentMode = UIViewContentModeScaleAspectFit;
//        self.bgImage.clipsToBounds = YES;
    }
    [self.view addSubview:self.bgImage];
    
    
    NSData *data1 = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"640x1136" withExtension:@"gif"]];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.bgImage.animatedImage = animatedImage1;
    
    [self nextMoveTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark  Rotation IOS6 이상
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}


#pragma mark -
#pragma mark  NSTimer
- (void)nextMoveTimer
{
    [NSTimer scheduledTimerWithTimeInterval:4.0f
                                     target:self
                                   selector:@selector(closeVC)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)closeVC
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
