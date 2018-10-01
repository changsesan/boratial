//
//  MainViewController.h
//  neighbor
//
//  Created by dj jang on 2014. 11. 7..
//  Copyright (c) 2014년 dj jang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate , UIGestureRecognizerDelegate , UIActionSheetDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *loadingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *btnBottom1;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom2;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom3;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom4;
@property (strong, nonatomic) UIActionSheet *actionActionSheet;

@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *selectedImageURL;
@property (nonatomic,retain)  NSString *bankPayUrlString;

@property (nonatomic, strong) UIImagePickerController *imageController;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (assign) CGPoint longtouchPostion;

- (void)requestForURL:(NSString *)textUrl;
- (void)setUserAgent;

@end


@interface UnpreventableUILongPressGestureRecognizer : UILongPressGestureRecognizer {
	
}
@end
