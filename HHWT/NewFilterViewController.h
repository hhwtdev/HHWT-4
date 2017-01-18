//
//  NewFilterViewController.h
//  HHWT
//
//  Created by Priya on 05/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NewFilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnClearAll;
- (IBAction)actionClearAll:(id)sender;
- (IBAction)actionApply:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageviewTitle;
@property(nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (nonatomic, assign) int selectionID;
@property (nonatomic, retain) NSString *cityID;




@end
