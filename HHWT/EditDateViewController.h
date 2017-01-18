//
//  EditDateViewController.h
//  HHWT
//
//  Created by sampath kumar on 20/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTripViewController.h"

#define EditDate_STORYBOARD_ID @"EditDateViewControllerSBID"

@interface EditDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@property (weak, nonatomic) IBOutlet UITextField *txtTripName;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;

@property (nonatomic, retain) DetailTripViewController *detailTripClass;


@end
