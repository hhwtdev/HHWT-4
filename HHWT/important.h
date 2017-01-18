//
//  important.h
//  HHWT
//
//  Created by Govind on 23/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"
#define tours @"TourCheckAvailabilitySBID"


@interface important : UIViewController

@property (nonatomic, retain) TourDetailModel *selectedTour;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end
