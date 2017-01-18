//
//  SelectCategoryViewController.h
//  HHWT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryViewController : HHWTViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTV;

@property BOOL *thingsSelected;
@property BOOL *foodSelected;
@property BOOL *palySelected;

@end
