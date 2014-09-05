//
//  DisplayViewController.h
//  VsMobile_FullWeb_OneWebView
//
//  Created by admin on 8/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UISplitViewControllerDelegate, UIWebViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *Display;
@property (weak, nonatomic) IBOutlet UIButton *Settings;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Activity;

@property id PageID;
@property id navigateTo;

@property int webviewI;
@property int imageI;

@property (strong, nonatomic) UIAlertView *settingsDone;
@property (strong, nonatomic) UIActivityViewController *shareActivity;

@property (strong,nonatomic) NSString *whereWasI;
@property (strong, nonatomic) NSString *lastPath;

@property BOOL isConflictual;
@property NSTimer *backgroundTimer;

@end
