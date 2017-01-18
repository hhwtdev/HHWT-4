//
//  TripSummaryViewController.h
//  HHWT
//
//  Created by sampath kumar on 09/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TRIP_SUMMARY_STORYBOARD_ID @"TripSummaryViewControllerSBID"

@interface TripSummaryViewController : HHWTViewController
@property (nonatomic, weak) IBOutlet UICollectionView *collectionV;
@property (nonatomic, weak) IBOutlet UITableView *tableV;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (nonatomic, weak) IBOutlet UIButton *addDate;
@property (weak, nonatomic) IBOutlet UIView *dateView;
- (IBAction)addDateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyData;
@property (nonatomic, retain) NSString *tripID;
@property (nonatomic, retain) NSString *getStartDate;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@end
