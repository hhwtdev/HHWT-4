//
//  ViewAllViewController.h
//  HHWT
//
//  Created by SYZYGY on 29/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ASStarRatingView.h"
#import "NewDealsTableViewCell.h"

@interface ViewAllViewController : UIViewController

@property (nonatomic,retain) NSString *keyStr;
@property (nonatomic,retain) NSMutableArray *datasArr;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *viewAllTable;
@property (weak, nonatomic) IBOutlet UITableView *dealsViewAllTable;
- (IBAction)backBtn:(id)sender;

@end
