//
//  DestinationViewController.h
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DESTINATION_STORYBOARD_ID @"DestinationViewControllerSBID"

@interface DestinationViewController : HHWTViewController
@property (nonatomic, retain) NSString *screenName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
