//
//  UITableViewCell_CellWithSwitch.h
//  OneWebView_NavigateByStep
//
//  Created by admin on 9/8/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellWithSwitch : UITableViewCell

@property IBOutlet UIView *view;
@property IBOutlet UILabel *title;
@property IBOutlet UISwitch *status;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
