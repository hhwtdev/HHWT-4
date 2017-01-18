//
//  MyTripsViewController.h
//  HHWT
//
//  Created by sampath kumar on 13/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_TRIP_SUMMARY_STORYBOARD_ID @"MyTripsViewControllerSBID"

@interface MyTripsViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyData;
@property (nonatomic, retain) NSString *cityID;
@property (retain, nonatomic)  NSString *elementID;
@property (assign, nonatomic)  BOOL isExploreActive;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
- (IBAction)actionAdd:(id)sender;


@end
