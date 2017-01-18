//
//  webViewc.m
//  HHWT
//
//  Created by Govind on 02/03/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//
#import "webViewc.h"

@interface webViewc()
@end
@implementation webViewc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Open Sans" size:22],
                                                                    NSForegroundColorAttributeName: tintColor
                                                                    };
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [self.navigationItem.titleView  setUserInteractionEnabled:YES];
    [self.navigationItem.titleView addGestureRecognizer:navSingleTap];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    NSString *urlString = @"https://www.dropbox.com/s/gwy41ycuppzyx1n/Have%20Halal%20Will%20Travel%20Korean%20language%20Guide%20For%20Muslims%20-%20v1.0%20%283%29.pdf?dl=1";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_govind loadRequest:urlRequest];
    
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