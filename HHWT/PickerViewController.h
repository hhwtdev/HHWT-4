//
//  PickerViewController.h
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PICKER_STORYBOARD_ID @"PickerViewControllerSBID"

@interface PickerViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (nonatomic, assign) BOOL isTourPicker;

@end
