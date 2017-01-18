//
//  FoodDetailViewController.h
//  HHWT
//
//  Created by sampath kumar on 05/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FoodViewController.h"

#define FoodDetailViewController_STORYBOARD_ID @"FoodDetailViewControllerSBID"
@class ASStarRatingView;

@interface FoodDetailViewController : HHWTViewController
@property (nonatomic, assign) int selectionID;
@property (nonatomic, assign) int selectionType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintFoodViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblFoodType;
@property (weak, nonatomic) IBOutlet UILabel *lblFoodClassifi;
@property (nonatomic, retain) NSString *cityID;

@property (weak, nonatomic) IBOutlet UIView *viewFood;
@property (weak, nonatomic) IBOutlet UILabel *lblFoodCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPrayerCount;
- (IBAction)mapAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)callAction:(id)sender;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *heights;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet ASStarRatingView *starRatings;
@property (weak, nonatomic) IBOutlet UILabel *lblReviews;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;

@property (weak, nonatomic) IBOutlet UILabel *lblAddres1;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress2;
@property (weak, nonatomic) IBOutlet UILabel *lblPhNo;
@property (weak, nonatomic) IBOutlet UILabel *lblWeb;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet ASStarRatingView *starRatings2;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (nonatomic, retain) NSString *getDistrict;

@property (weak, nonatomic) IBOutlet UILabel *lblOpen;
@property (weak, nonatomic) IBOutlet UILabel *lblThingsCount;

@property (weak, nonatomic) IBOutlet UILabel *lblClose;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *commentsTable;

@property (nonatomic, strong) NSDictionary *selectedLocationDict;

@end
