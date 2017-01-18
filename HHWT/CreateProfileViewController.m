//
//  CreateProfileViewController.m
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "CreateProfileViewController.h"

@interface CreateProfileViewController ()

@end

@implementation CreateProfileViewController

- (void)viewDidLoad
{
    self.nameFld.presentInView =self.view;
    [self.nameFld addRegx:REGEX_USER_NAME withMsg:@"Enter Valid Name"];
    
    self.navigationController.navigationBarHidden = NO;
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *countryStr =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"SELECTEDCOUNTRY"]];
    
    if (countryStr == (NSString*) [NSNull null] || countryStr.length == 0 || [countryStr isEqualToString:@"(null)"])
    {
        NSLog(@"Not selected country");
    }
    else
    {
        self.countryFld.text =countryStr;
    }

    
    self.navigationItem.title = @"Create Your Profile";
    NSDictionary *attrDictterms = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:20.0],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    [self.navigationController.navigationBar setTitleTextAttributes:attrDictterms];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"Back";
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectCountryBtn:(id)sender
{
    SelectCountryViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCountryViewController"];
    [self.navigationController pushViewController:initialVC animated:YES];
}
- (IBAction)nextBtn:(id)sender
{
    if([self.nameFld validate])
    {
        if (self.countryFld.text.length !=0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.nameFld.text forKey:@"REGISTRATIONNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:self.countryFld.text forKey:@"REGISTRATIONCOUNTRY"];
            
            UserNameViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserNameViewController"];
            [self.navigationController pushViewController:initialVC animated:YES];
        }
    }
}

@end
