//
//  GuidesViewController.h
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Reachability.h"

#define GUIDE_STORYBOARD_ID @"GuidesViewControllerSBID"

@interface GuidesViewController : HHWTViewController <UITableViewDelegate , UITableViewDataSource> 
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@end
