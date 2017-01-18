//
//  CreateTripViewController.h
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CREATE_TRIP_STORYBOARD_ID @"CreateTripViewControllerSBID"
#define addtripss @"AddTripViewControllerSBID"


@interface CreateTripViewController : HHWTViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) IBOutlet UIView *baseV;
@property (weak, nonatomic) IBOutlet UITextField *tripName;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateTrip;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (nonatomic, retain) NSString *cityIDFromMyTrips;;
@property (nonatomic, retain) NSString *dataele;


- (IBAction)createTripAction:(id)sender;
- (IBAction)startDateAction:(id)sender;
- (IBAction)endDateAction:(id)sender;

@end
