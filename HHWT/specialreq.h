//
//  specialreq.h
//  HHWT
//
//  Created by Govind on 23/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"
#define home @"ToursViewControllerSBID"



@interface specialreq : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) TourDetailModel *selectedTour;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end
