//
//  ReviewTableViewController.h
//  HHWT
//
//  Created by Dipin on 13/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface ReviewTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *lblVisitedDate;
@property (weak, nonatomic) IBOutlet UITextField *txtPurpose;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDesc;

@property (weak, nonatomic) IBOutlet ASStarRatingView *starView;
@property (nonatomic, strong) NSDictionary *dataelement;
@property (weak, nonatomic) IBOutlet UIView *viewVisitedDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)actionSubmit:(id)sender;
- (IBAction)actionVisitedDate:(id)sender;

@end
