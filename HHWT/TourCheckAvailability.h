//
//  TourCheckAvailability.h
//  HHWT
//
//  Created by SampathKumar on 07/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"

#define TOURS_CHECK_STORYBOARD_ID @"TourCheckAvailabilitySBID"
#define specialrequest @"specialreq"


@interface TourCheckAvailability : HHWTViewController
@property (nonatomic, retain) TourDetailModel *selectedTour;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UILabel *labelo;

@end
