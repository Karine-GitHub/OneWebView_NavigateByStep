//
//  DisplayViewController.m
//  VsMobile_FullWeb_OneWebView
//
//  Created by admin on 8/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
#import "AppDelegate.h"
#import "DisplayViewController.h"
#import "DynamicToolBar.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController {
    AppDelegate *appDel;
    NSString *errorMsg;
    NSMutableDictionary *application;
    NSMutableArray *allPages;
    NSMutableArray *appDependencies;
    NSMutableArray *pageDependencies;
    NSMutableArray *pageSteps;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

// Pas appelé lors du retour depuis les settings
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDone:) name:@"SettingsModificationNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDone:) name:@"NoModificationNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conflictIssue:) name:@"ConflictualSituationNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAppDone:) name:@"ConfigureAppNotification" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.isConflictual = NO;
}

#pragma mark NOTIFICATIONS
- (void)settingsDone:(NSNotification *)notification
{
    @synchronized(self) {
        if ([notification.name isEqualToString:@"SettingsModificationNotification"]) {
            reloadApp = YES;
            [self viewDidLoad];
        } else {
            reloadApp = NO;
            self.isConflictual = NO;
            self.navigationItem.title = self.whereWasI;
            self.Img.hidden = YES;
            self.Display.hidden = NO;
        }
    }
}
- (void)conflictIssue:(NSNotification *)notification
{
    @synchronized(self){
        self.isConflictual = YES;
        [self viewDidLoad];
    }
}
- (void)configureAppDone:(NSNotification *)notification
{
    // Check if settings view is visible
    @synchronized(self){
        if ([self.navigationController.visibleViewController isKindOfClass:[DisplayViewController class]])
        {
            if (appDel.downloadIsFinished) {
                @try {
                    [NSThread sleepForTimeInterval:3.0];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    self.navigationItem.title = self.whereWasI;
                    // Alert user that downloading is finished
                    errorMsg = [NSString stringWithFormat:@"The new settings is now supported. The reconfiguration of the Application is done."];
                    self.SettingsDone = [[UIAlertView alloc] initWithTitle:@"Reconfiguration Successful" message:errorMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [self.SettingsDone performSelectorOnMainThread:@selector(show) withObject:self waitUntilDone:YES];
                } @finally {
                    reloadApp = NO;
                    forceDownloading = NO;
                }
            }
        }
    }
}
#pragma mark END OF NOTIFICATIONS


- (void)reloadApp
{
    @synchronized(self) {
        // Check if menu view is visible
        
        if (appDel == Nil) {
            appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        reloadApp = YES;
        [appDel configureApp];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    @synchronized(self){
        [super viewDidLoad];
        
        // Do any additional setup after loading the view, typically from a nib.
        appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.Display.delegate = self;
        
        if ([self.navigationItem.title isEqualToString:@"Menu"] || (!self.NavigateTo && !self.PageID)) {
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            self.navigationItem.hidesBackButton = NO;
            UIImage *backToMenuIcon = [[UIImage imageNamed:@"BackButtonHome-44.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIBarButtonItem *backMenuIcon = [[UIBarButtonItem alloc] initWithImage:backToMenuIcon style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackMenuIcon:)];
            [self.navigationItem setRightBarButtonItem:backMenuIcon];
        }
        self.navigationItem.title = self.whereWasI;
        
        [self.Img setImage:[UIImage imageNamed:@"LaunchImage-700"]];
        
        [self.Display sizeToFit];
        [self.Display.scrollView sizeToFit];

        CGFloat height = [[self.Display stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
        CGRect frameWebview = self.Display.frame;
        CGRect frameScrollview = self.Display.scrollView.frame;
        frameWebview.size.height = height;
        frameScrollview.size.height = height;
        [self.Display setFrame:frameWebview];
        [self.Display.scrollView setFrame:frameScrollview];
        [self.Display.scrollView setContentSize:CGSizeMake(frameScrollview.size.width, frameScrollview.size.height)];

        [self performSelectorInBackground:@selector(refreshApplicationByNewDownloading) withObject:self];
        
        if (self.isConflictual) {
            self.navigationItem.title = @"Conflictual situation";
            self.Img.hidden = NO;
            self.Display.hidden = YES;
        } else if (reloadApp) {
            self.navigationItem.title = @"Reconfiguration in progress";
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            self.Img.hidden = NO;
            self.Display.hidden = YES;
            [self performSelectorInBackground:@selector(reloadApp) withObject:self];
        } else {
            self.Img.hidden = YES;
            self.Display.hidden = NO;
        }
        
        [self initApp];
    }
}

- (void)initApp
{
    // Get Application json file
    @try {
        UIAlertView *alertConflict = [[UIAlertView alloc] initWithTitle:@"Conflictual Situation" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Settings",nil];
        float size = [[AppDelegate getSizeOf:APPLICATION_SUPPORT_PATH] floatValue];
        if (cacheIsEnabled && size == 0.0) {
            self.isConflictual = NO;
            alertConflict.message = @"Impossible to download content. The cache mode is enabled : it blocks the downloading. Do you want to disable it ?";
            [alertConflict show];
        } else if (appDel.roamingSituation && !roamingIsEnabled) {
            self.isConflictual = NO;
            alertConflict.message = @"Impossible to download content. You are currently in Roaming case and the roaming mode is disabled : it blocks the downloading. Do you want to enable it ?";
            [alertConflict show];
        } else if (!self.Display.hidden) {
            UIAlertView *alertNoConnection = [[UIAlertView alloc] initWithTitle:@"Application fails" message:nil delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
            if (appDel.isDownloadedByNetwork || appDel.isDownloadedByFile) {
                if (APPLICATION_FILE != Nil) {
                    appDependencies = [APPLICATION_FILE objectForKey:@"Dependencies"];
                    allPages = [APPLICATION_FILE objectForKey:@"Pages"];
                    [self configureViewWithPageID:self.PageID withStepName:self.NavigateTo withFeedId:self.FeedID];
                }
            } else if (!appDel.isDownloadedByNetwork) {
                alertNoConnection.message = @"Impossible to download content on the server. The network connection is too low or off. The application will shut down. Please try later.";
                [alertNoConnection show];
            } else if (!appDel.isDownloadedByFile) {
                alertNoConnection.message = @"Impossible to download content file. The application will shut down. Sorry for the inconvenience.";
                [alertNoConnection show];
            }
        }
    }
    @catch (NSException *e) {
        errorMsg = [NSString stringWithFormat:@"An error occured during the Loading of the Application : %@, reason : %@", e.name, e.reason];
        UIAlertView *alertNoConnection = [[UIAlertView alloc] initWithTitle:@"Application fails" message:errorMsg delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
        [alertNoConnection show];
    }
}

- (void)configureViewWithPageID:(NSString *)pageId withStepName:(NSString *)stepName withFeedId:(NSString *)feedId
{
    @try {
        NSURL *url = [NSURL fileURLWithPath:APPLICATION_SUPPORT_PATH isDirectory:YES];
        NSString *content = nil;
        NSString *path = nil;
        NSString *externalUrl = nil;
        
        for (NSMutableDictionary *page in allPages) {
            if (pageId || [[page objectForKey:@"TemplateType"] isEqualToString:@"Menu"]) {
                // Get Page's Dependencies
                if ([page objectForKey:@"Dependencies"] != [NSNull null]) {
                    pageDependencies = [page objectForKey:@"Dependencies"];
                }
                // Get Page's Steps
                if ([page objectForKey:@"Steps"] != [NSNull null]) {
                    pageSteps = [page objectForKey:@"Steps"];
                }
                
                if (!pageId && !stepName && [[page objectForKey:@"TemplateType"] isEqualToString:@"Menu"]) {
                    if ([[page objectForKey:@"IsExternal"] isEqual:[NSNumber numberWithBool:YES]]) {
                        externalUrl = [page objectForKey:@"ExternalUrl"];
                    } else {
                        NSDictionary *only = [pageSteps objectAtIndex:0];
                        content = [AppDelegate createHTMLwithContent:[only objectForKey:@"HtmlContent"] withAppDep:appDependencies withPageDep:pageDependencies];
                        path = [NSString stringWithFormat:@"%@%@", APPLICATION_SUPPORT_PATH, [only objectForKey:@"Name"]];
                        
                        // Set Page's title
                        self.navigationItem.title = [page objectForKey:@"Title"];
                        // Set Toolbar
                        [self.view addSubview:[DynamicToolBar createToolBarIn:self.view withSteps:[only objectForKey:@"ToolBarOptions"]]];
                    }
                } else if ([pageId isEqual:[page objectForKey:@"Id"]] && !stepName && ![[page objectForKey:@"TemplateType"] isEqualToString:@"Menu"]) {
                    if ([[page objectForKey:@"IsExternal"] isEqual:[NSNumber numberWithBool:YES]]) {
                        externalUrl = [page objectForKey:@"ExternalUrl"];
                    } else {
                        NSDictionary *only = [pageSteps objectAtIndex:0];
                        content = [AppDelegate createHTMLwithContent:[only objectForKey:@"HtmlContent"] withAppDep:appDependencies withPageDep:pageDependencies];
                        path = [NSString stringWithFormat:@"%@%@", APPLICATION_SUPPORT_PATH, [only objectForKey:@"Name"]];
                        
                        // Set Page's title
                        self.navigationItem.title = [page objectForKey:@"Title"];
                        // Set Toolbar
                        [self.view addSubview:[DynamicToolBar createToolBarIn:self.view withSteps:[only objectForKey:@"ToolBarOptions"]]];
                    }
                } else if ([pageId isEqual:[page objectForKey:@"Id"]] && stepName && feedId && ![[page objectForKey:@"TemplateType"] isEqualToString:@"Menu"]) {
                    if ([[page objectForKey:@"IsExternal"] isEqual:[NSNumber numberWithBool:YES]]) {
                        externalUrl = [page objectForKey:@"ExternalUrl"];
                    } else {
                        for (NSDictionary *step in pageSteps) {
                            NSLog(@"Step : %@", [step objectForKey:@"Name"]);
                            if ([stepName isEqual:[step objectForKey:@"Name"]]) {
                                content = [AppDelegate createHTMLwithContent:[step objectForKey:@"HtmlContent"] withAppDep:appDependencies withPageDep:pageDependencies];
                                path = [NSString stringWithFormat:@"%@%@", APPLICATION_SUPPORT_PATH, [step objectForKey:@"Name"]];
                                // Set Page's title
                                self.navigationItem.title = [page objectForKey:@"Title"];
                                // Set Toolbar
                                [self.view addSubview:[DynamicToolBar createToolBarIn:self.view withSteps:[step objectForKey:@"ToolBarOptions"]]];
                            }
                        }
                    }
                }
                if ((content && path) || externalUrl) {
                    break;
                }
            }
        }
        if (content && path) {
            // Present html content
            BOOL success = false;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = [[NSError alloc] init];
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            success = [fileManager createFileAtPath:path contents:data attributes:nil];
            if (!success) {
                NSLog(@"An error occured during the Saving of the html file : %@", error);
                NSException *e = [NSException exceptionWithName:error.localizedDescription reason:error.localizedFailureReason userInfo:error.userInfo];
                @throw e;
            }
            self.viewInfo = [NSString stringWithFormat:@"%@?%@", self.NavigateTo, self.PageID];
            
            // Load HTML
            if (pageId && stepName && feedId) {
                NSString *urlWithQuery = [NSString stringWithFormat:@"%@?%@#%@", url, stepName, feedId];
                url = [NSURL URLWithString:urlWithQuery];
                NSString *result = [self.Display stringByEvaluatingJavaScriptFromString:@"getPageNavigationInfo()"];
                NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];
                // Set info for stepper
                self.currentDetailsId = (long)[jsonResult objectForKey:@"currentItemIndex"];
                self.itemsCount = (long)[jsonResult objectForKey:@"itemCount"];
                // Set Page's title
                self.navigationItem.title = [jsonResult objectForKey:@"text"];
            }
            [self.Display loadHTMLString:content baseURL:url];
        } else if (externalUrl) {
           // Redirect with safari
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:externalUrl]];
        }
    }
    @catch (NSException *exception) {
        errorMsg = [NSString stringWithFormat:@"An error occured during the Configuration of the view Menu : %@, reason : %@", exception.name, exception.reason];
        UIAlertView *alertNoConnection = [[UIAlertView alloc] initWithTitle:@"Application fails" message:errorMsg delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
        [alertNoConnection show];
    }
}

#pragma mark - Web View
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //self.Img.hidden = NO;
    //self.Display.hidden = YES;
    [self.Activity setHidden:NO];
    [self.Activity startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView sizeToFit];
    [webView.scrollView sizeToFit];
    
    if (![self.navigationItem.title isEqualToString:@"Menu"]) {
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
        CGRect frameWebview = webView.frame;
        CGRect frameScrollview = webView.scrollView.frame;
        frameWebview.size.height = height + 150;
        frameScrollview.size.height = height + 150;
        [webView setFrame:frameWebview];
        [webView.scrollView setFrame:frameScrollview];
        [webView.scrollView setContentSize:CGSizeMake(frameScrollview.size.width, frameScrollview.size.height + 150)];
    }

    [self.Activity stopAnimating];
    [self.Activity setHidden:YES];
    //self.Img.hidden = YES;
    //self.Display.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /*[UIView beginAnimations:@"animationID" context:nil];
     [UIView setAnimationDuration:2.0f];
     [UIView setAnimationCurve:UIViewAnimationCurveLinear];
     [UIView setAnimationRepeatAutoreverses:NO];
     [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
     [UIView commitAnimations];*/
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //Absolute string : file:///Users/admin/Library/Application%20Support/iPhone%20Simulator/7.1/Applications/FDE30D9E-6C0D-4F1D-96F7-E7B1174A17A2/Library/Application%20Support/details.html
    //Absolute Url : file:///Users/admin/Library/Application%20Support/iPhone%20Simulator/7.1/Applications/FDE30D9E-6C0D-4F1D-96F7-E7B1174A17A2/Library/Application%20Support/details.html
    //Relative string : file:///Users/admin/Library/Application%20Support/iPhone%20Simulator/7.1/Applications/FDE30D9E-6C0D-4F1D-96F7-E7B1174A17A2/Library/Application%20Support/details.html
    //Relative Path : /Users/admin/Library/Application Support/iPhone Simulator/7.1/Applications/FDE30D9E-6C0D-4F1D-96F7-E7B1174A17A2/Library/Application Support/details.html
    //Path url : /Users/admin/Library/Application Support/iPhone Simulator/7.1/Applications/FDE30D9E-6C0D-4F1D-96F7-E7B1174A17A2/Library/Application Support/details.html
    
    // Menu vers actualités : http://goto/?9104542f-9459-4e37-b81e-15bc4dcd0102
    // Actu2 vers detailsActu2 : http://gotostep/?Step2.Mobile.html?Id=0004542f-9459-4e37-b81e-15bc4dcd9901&
    
    
    
    long index = [APPLICATION_SUPPORT_PATH length] - 1;
    NSString *path = [APPLICATION_SUPPORT_PATH substringToIndex:index];
    NSString *longPath;
    
    self.whereWasI = self.navigationItem.title;
    
    if (self.NavigateTo && self.PageID) {
        longPath = [NSString stringWithFormat:@"%@/%@", path, self.NavigateTo];
    }
    
    /*NSLog(@"URL : %@", request.URL);
     NSLog(@"Query : %@", [request.URL query]);
     NSLog(@"Relative path : %@", [request.URL relativePath]);
     NSLog(@"Host : %@", [request.URL host]);
     NSLog(@"Navigation type : %d", navigationType);*/
    
    if ([[request.URL relativePath] isEqualToString:path]) {
        // First loading
        return YES;
    } else if ([request.URL query] != nil && [[request.URL host] isEqualToString:@"goto"]) {
        DisplayViewController *displayView = (DisplayViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"displayView"];
        displayView.NavigateTo = nil;
        displayView.PageID = [request.URL query];
        displayView.FeedID = nil;
        [self.navigationController pushViewController:displayView animated:YES];
        return NO;
    } else if ([request.URL query] != nil && [[request.URL host] isEqualToString:@"gotostep"]) {
        DisplayViewController *displayView = (DisplayViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"displayView"];
        
        NSRange pointSeparator = [[request.URL query] rangeOfString:@"?"];
        if (pointSeparator.location == NSNotFound) {
            displayView.NavigateTo = [request.URL query];
            displayView.PageID = nil;
            displayView.FeedID = nil;
        } else {
            displayView.NavigateTo = [[request.URL query] substringToIndex:pointSeparator.location];
            // 2° param de la query : ID du feed
            displayView.FeedID = [[request.URL query] substringFromIndex:pointSeparator.location +1];
            displayView.PageID = self.PageID;
        }
        [self.navigationController pushViewController:displayView animated:YES];
        return NO;
    } else if ([request.URL query] != nil && [[request.URL host] isEqualToString:@"backtostep"]) {
        // HTML back button => simulate back button click in navigation bar
        [[self navigationController] popViewControllerAnimated:YES];
        return NO;
    } else if ([[request.URL host] isEqualToString:@"gotomenu"]) {
        // HTML back button => simulate back button click in navigation bar
        [[self navigationController] popViewControllerAnimated:YES];
        return NO;
    } else {
        // Redirect with safari
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return NO;
}
- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    errorMsg = [NSString stringWithFormat:@"<html><center><font size=+4 color='red'>An error occured :<br>%@</font></center></html>", error.localizedDescription];
    [self.Display loadHTMLString:[AppDelegate createHTMLwithContent:errorMsg withAppDep:nil withPageDep:nil] baseURL:nil];
}

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        // Fermer l'application
        //Home button
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        // Wait while app is going background
        [NSThread sleepForTimeInterval:2.0];
        exit(0);
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
        // Go to settings
        self.isConflictual = NO;
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        SettingsView *showSettings = [[SettingsView alloc] init];
        showSettings = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsView"];
        [self.navigationController pushViewController:showSettings animated:YES];
        
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        self.isConflictual = NO;
        self.Img.hidden = YES;
        self.Display.hidden = NO;
    }
}

// Do not change the date if just the refresh variable has changed
- (void) refreshApplicationByNewDownloading
{
    @synchronized(self){
        if (appDel == Nil) {
            appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        long interval;
        if ([appDel.refreshDuration isEqualToString:@"heure"]) {
            interval= [appDel.refreshInterval doubleValue] * 60 * 60;
        } else if ([appDel.refreshDuration isEqualToString:@"jour"]) {
            interval = [appDel.refreshInterval integerValue] * 60 * 60 * 24;
        }
        
        if (self.backgroundTimer.timeInterval != interval) {
            self.backgroundTimer = [NSTimer timerWithTimeInterval:[appDel.refreshInterval integerValue] * 60 target:self selector:@selector(forceDownloadingApplication:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.backgroundTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void) forceDownloadingApplication:(NSTimer *)timer
{
    @synchronized(self){
        if (appDel == Nil) {
            appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
        NSDate *downloadDate = [formatDate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadDate"]];
        
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSinceDate:downloadDate];
        NSLog(@"Current interval = %f, Choosen Interval = %f", currentInterval, timer.timeInterval);
        
        if (currentInterval >= timer.timeInterval) {
            // Download all
            appDel.autoRefresh = YES;
            [appDel performSelectorInBackground:@selector(configureApp) withObject:appDel];
        }
    }
}

- (void)clickBackMenuIcon:(id)sender
{
    DisplayViewController *displayView = (DisplayViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"displayView"];
    displayView.NavigateTo = nil;
    displayView.PageID = nil;
    displayView.FeedID = nil;
    [self.navigationController pushViewController:displayView animated:YES];
}

@end
