//
//  DetailTableViewController.h
//  HHWT
//
//  Created by Priya on 09/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewAllViewController.h"
#import "LocationViewController.h"
#import "MyTripsViewController.h"
#import "TourDetail2.h"
#import "AppDelegate.h"

@interface DetailTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableDictionary *dictDetails;
@property (nonatomic, retain) NSString *datasIdStr;
@property (nonatomic, retain) NSMutableArray *attractionsArr;
@property (nonatomic, retain) NSMutableArray *foodPlacesArr;
@property (nonatomic, retain) NSMutableArray *prayerSpacesArr;


@property (nonatomic, retain) NSDictionary *selectedCityDict;


@end
