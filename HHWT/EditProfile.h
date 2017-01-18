//
//  EditProfile.h
//  HHWT
//
//  Created by SampathKumar on 18/09/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EditProfile_STORYBOARD_ID @"EditProfileSBID"

@interface EditProfile : HHWTViewController

@property (nonatomic, retain) NSString *editType;

@property (weak, nonatomic) IBOutlet UILabel *lblTopTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *btnObj;
- (IBAction)btnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateChange:(id)sender;

@end
