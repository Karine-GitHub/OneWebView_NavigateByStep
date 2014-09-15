//
//  DynamicToolBar.h
//  OneWebView_NavigateByStep
//
//  Created by admin on 9/9/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL addInCalendar;
static double currentStepValue;

@interface DynamicToolBar : NSObject

+ (UIToolbar *) createToolBarIn:(UIView *)parentView withSteps:(NSDictionary *)steps;

+ (void) settingsClick:(id)sender;
+ (void) dataRefreshClick:(id)sender;
+ (void) searchClick:(id)sender;
+ (void) filterClick:(id)sender;
+ (void) sortClick:(id)sender;
+ (void) shareClick:(id)sender;
+ (void) geolocationClick:(id)sender;
+ (void) contactClick:(id)sender;
+ (void) calendarClick:(id)sender;
+ (void) navigateClick:(UIStepper *)stepper;


@end
