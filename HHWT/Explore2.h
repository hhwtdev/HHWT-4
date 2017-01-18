//
//  Explore2.h
//  HHWT
//
//  Created by SampathKumar on 16/10/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EXPLORE_2 @"Explore2SBID"

@interface Explore2 : HHWTViewController

@property (nonatomic, retain) NSDictionary *selectedCityDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscover;
@property (weak, nonatomic) IBOutlet UIButton *btnThingsToDo;
@property (weak, nonatomic) IBOutlet UIButton *btnFood;
@property (weak, nonatomic) IBOutlet UIButton *btnDeals;
@property (weak, nonatomic) IBOutlet UITableView *tblView1;
@property (weak, nonatomic) IBOutlet UITableView *tblView2;
@property (weak, nonatomic) IBOutlet UITableView *tblView3;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBaseViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *explorehead;
@property (weak, nonatomic) IBOutlet UILabel *exploreexpl;


- (IBAction)exploreAllAction:(id)sender;
- (IBAction)TryTripPlannerAction:(id)sender;


@end
