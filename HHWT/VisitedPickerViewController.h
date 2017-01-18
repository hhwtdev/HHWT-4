//
//  VisitedPickerViewController.h
//  HHWT
//
//  Created by Dipin on 14/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "HHWTViewController.h"

#define VISITED_PICKER_STORYBOARD_ID @"VisitedPickerViewController"


@interface VisitedPickerViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@end
