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
@property (strong, nonatomic) IBOutlet UIImageView *Img;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Activity;

@property id PageID;
@property id NavigateTo;

@property long webviewI;
@property long imageI;

@property (strong, nonatomic) UIAlertView *SettingsDone;
@property (strong, nonatomic) UIActivityViewController *ShareActivity;

@property (strong,nonatomic) NSString *whereWasI;
@property NSString *viewInfo;

@property BOOL isConflictual;
@property NSTimer *backgroundTimer;

@end
