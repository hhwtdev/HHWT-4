//
//  CreateProfileViewController.h
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCountryViewController.h"
#import "UserNameViewController.h"
#import "TextFieldValidator.h"

#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"

@interface CreateProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet TextFieldValidator *nameFld;
@property (weak, nonatomic) IBOutlet TextFieldValidator *countryFld;
- (IBAction)selectCountryBtn:(id)sender;
- (IBAction)nextBtn:(id)sender;

@end
