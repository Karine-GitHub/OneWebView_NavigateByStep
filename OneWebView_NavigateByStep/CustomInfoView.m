//
//  CustomInfoView.m
//  OneWebView_NavigateByStep
//
//  Created by admin on 9/17/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "CustomInfoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.8];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 20)];
        [self.infoLabel setTextAlignment:NSTextAlignmentCenter];
        [self.infoLabel setTextColor:[UIColor whiteColor]];
        
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activity setFrame:CGRectMake((self.frame.size.width/2 - 25), 40, 50, 50)];
        [self.activity setHidesWhenStopped:YES];
        [self.activity setHidden:NO];
        [self.activity startAnimating];
        
        [self addSubview:self.infoLabel];
        [self addSubview:self.activity];
    }
    return self;
}

@end
