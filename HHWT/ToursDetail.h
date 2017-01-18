//
//  ToursDetail.h
//  HHWT
//
//  Created by SampathKumar on 31/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOURS_DETAIL_STORYBOARD_ID @"ToursDetailSBID"

@interface ToursDetail : HHWTViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;

@end
