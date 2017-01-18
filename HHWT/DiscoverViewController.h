//
//  DiscoverViewController.h
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISCOVER_STORYBOARD_ID @"DiscoverViewControllerSBID"

@interface DiscoverViewController : HHWTViewController

@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
