//
//  TourDetail2.h
//  HHWT
//
//  Created by SampathKumar on 07/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"
#import "ASStarRatingView.h"

#define TOURS_DETAIL2_STORYBOARD_ID @"TourDetail2SBID"
#define govinddec @"makeenquiry"

@interface TourDetail2 : HHWTViewController
@property (nonatomic, retain) TourDetailModel *selectedTour;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lblReview;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *lblOverview;
@property (weak, nonatomic) IBOutlet UILabel *lblHighlights;
@property (weak, nonatomic) IBOutlet UILabel *lblWhatExpect;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblInclusion;
@property (weak, nonatomic) IBOutlet UILabel *lblDepartPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblDepartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDepartTime;

@property (weak, nonatomic) IBOutlet UILabel *checkbutton;
@property (weak, nonatomic) IBOutlet UIButton *checksecond;

@end
