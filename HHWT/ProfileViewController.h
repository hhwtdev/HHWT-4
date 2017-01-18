//
//  ProfileViewController.h
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import <UIKit/UIKit.h>


#define PROFILE_STORYBOARD_ID @"ProfileViewControllerSBID"


@interface ProfileViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
- (IBAction)editImage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeightConstrant;
- (IBAction)contactUs:(id)sender;

@end
