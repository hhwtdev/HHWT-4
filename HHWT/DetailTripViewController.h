//
//  DetailTripViewController.h
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DETAIL_TRIP_STORYBOARD_ID @"DetailTripViewControllerSBID"

@interface DetailTripViewController : HHWTViewController
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) IBOutlet UILabel *lblTripName;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchSeoul;
@property (nonatomic, weak) IBOutlet UIButton *addDate;
- (IBAction)addDateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;


@end
