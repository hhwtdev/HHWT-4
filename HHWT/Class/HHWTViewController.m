//
//  HHWTViewController.m
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "HHWTViewController.h"

@interface HHWTViewController ()
@end
@implementation HHWTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *tintColor = [UIColor colorWithRed:50/255.0f green:204/255.0f blue:203/255.0f alpha:1.0f];
    
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:tintColor];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Open Sans" size:20],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    }

-(void)navSingleTap
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
