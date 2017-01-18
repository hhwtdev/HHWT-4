//
//  ListPlacesViewController.h
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ListPlacesViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSArray *lists;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;

@end
