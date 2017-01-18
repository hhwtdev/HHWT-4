//
//  ForgetPassword.h
//  HHWT
//
//  Created by SampathKumar on 18/09/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

#define FORGET_STORYBOARD_ID @"ForgetPasswordSBID"

@interface ForgetPassword : HHWTViewController
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtField;
- (IBAction)btnAction:(id)sender;

@end
