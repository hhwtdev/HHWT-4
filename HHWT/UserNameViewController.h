//
//  UserNameViewController.h
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"

@interface UserNameViewController : UIViewController
{
    NSMutableData *mutUsernameData;
    NSURLConnection *usernameConnection;
    
    NSMutableData *mutRegistrationData;
    NSURLConnection *registrationConnection;
    
    UIStoryboard *storyBoard;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameFld;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *msgImage;
- (IBAction)nextBtn:(id)sender;

@end
