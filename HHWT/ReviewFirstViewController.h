//
//  ReviewFirstViewController.h
//  HHWT
//
//  Created by Dipin on 13/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "HHWTViewController.h"
#define REVIEW_SELECT_CITY @"ReviewFirstViewController"

@interface ReviewFirstViewController : HHWTViewController
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
- (IBAction)actionSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSeoul;
@end
