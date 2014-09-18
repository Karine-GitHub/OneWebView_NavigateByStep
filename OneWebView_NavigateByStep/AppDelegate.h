//
//  AppDelegate.h
//  VsMobile_FullWeb_OneWebView
//
//  Created by admin on 8/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "DisplayViewController.h"
#import "SettingsView.h"

// GLOBAL VARIABLES json files
extern NSDictionary *APPLICATION_FILE;
extern NSString *APPLICATION_SUPPORT_PATH;
extern BOOL forceDownloading;
extern BOOL reloadApp;
extern BOOL refreshByToolbar;
extern BOOL cacheIsEnabled;
extern BOOL roamingIsEnabled;
extern BOOL roamingSituation;
// END GLOBAL VARIABLES

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSData *applicationDatas;

@property long VersionID;

// Settings
@property BOOL autoRefresh;
@property NSNumber *refreshInterval;
@property NSString *refreshDuration;
@property NSDate *downloadDate;

// Used for checking if downloading is OK (differentiation for setting an appropriate error message)
@property BOOL serverIsOk;
@property BOOL downloadIsFinished;
@property BOOL isDownloadedByNetwork;
@property BOOL isDownloadedByFile;

// Used for WebApi : query
@property (strong, nonatomic) NSString *const OS;
@property (strong, nonatomic) NSString *deviceType;

- (void) configureApp;
- (BOOL) testConnection;
- (BOOL) testFastConnection;
+ (BOOL) serviceStatusFor:(NSString *)statusName;
+ (NSNumber *) getSizeOf:(NSString *)path;
+ (NSMutableString *) addFiles:(NSArray *)dependencies;
+ (NSString *)createHTMLwithContent:(NSString *)htmlContent withAppDep:(NSArray *)appDep withPageDep:(NSArray *)pageDep;

@end
