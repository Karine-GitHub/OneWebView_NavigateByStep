//
//  DisplayViewController.h
//  VsMobile_FullWeb_OneWebView
//
//  Created by admin on 8/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInfoView.h"
#import "DynamicToolBar.h"

@interface DisplayViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UIWebViewDelegate,ABUnknownPersonViewControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *Display;
@property (strong, nonatomic) IBOutlet UIImageView *Img;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Activity;

@property NSString *PageID;
@property NSString *NavigateTo;
@property NSString *FeedID;

@property (strong, nonatomic) UIAlertView *SettingsDone;
@property (strong, nonatomic) UIActivityViewController *ShareActivity;
@property CustomInfoView *customactivity;
@property UIViewController *lastController;

@property (strong,nonatomic) NSString *whereWasI;
@property (strong,nonatomic) NSString *viewInfo;

@property BOOL isMenu;

@property BOOL isConflictual;
@property NSTimer *backgroundTimer;

- (void)reloadApp;
- (void)initApp;
- (void)configureViewWithPageID:(NSString *)pageId withStepName:(NSString *)stepName withFeedId:(NSString *)feedId;

- (void) refreshApplicationByNewDownloading;
- (void) forceDownloadingApplication:(NSTimer *)timer;

- (void)configureAppDone:(NSNotification *)notification;
- (void)conflictIssue:(NSNotification *)notification;
- (void)settingsDone:(NSNotification *)notification;

@end
