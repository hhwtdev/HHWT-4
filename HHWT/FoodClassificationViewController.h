//
//  FoodClassificationViewController.h
//  HHWT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodClassificationViewController : HHWTViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *foodTV;
@property NSString *categoryName;
@end
