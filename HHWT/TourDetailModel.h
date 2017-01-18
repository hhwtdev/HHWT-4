//
//  TourDetailModel.h
//  HHWT
//
//  Created by SampathKumar on 06/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TourDetailModel : NSObject

@property (nonatomic, retain) NSString *departuredate;
@property (nonatomic, retain) NSString *departurepoint;
@property (nonatomic, retain) NSString *departuretime;

@property (nonatomic, retain) NSString *duration;

@property (nonatomic, retain) NSString *addi_info;
@property (nonatomic, retain) NSString *cancellation_policy;
@property (nonatomic, retain) NSString *contentString;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *enquiry;
@property (nonatomic, retain) NSString *inclusionandexclusion;

@property (nonatomic, retain) NSString *highlights;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *returndetails;


@property (nonatomic, retain) NSString *tour_classification_one;
@property (nonatomic, retain) NSString *tour_classification_two;
@property (nonatomic, retain) NSString *tour_opt_info;
@property (nonatomic, retain) NSString *tour_opt_link;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *whatcanyouexpect;


@property (nonatomic, assign) int tourID;
@property (nonatomic, retain) NSString *imgFour;
@property (nonatomic, retain) NSString *imgThree;
@property (nonatomic, retain) NSString *imgTwo;
@property (nonatomic, retain) NSString *imgOne;
@property (nonatomic, retain) NSString *longOverview;
@property (nonatomic, retain) NSString *overview1;
@property (nonatomic, retain) NSString *overview2;
@property (nonatomic, retain) NSString *overviews;
@property (nonatomic, retain) NSString *rateVal;
@property (nonatomic, assign) int totalReviews;
@property (nonatomic, assign) int sellingRateVal;
@property (nonatomic, assign) int snoVal;
@property (nonatomic, assign) int subID;
@property (nonatomic, retain) NSString *tourType;

@end
