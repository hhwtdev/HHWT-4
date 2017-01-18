//
//  AddPlacesViewController1.h
//  HHWT
//
//  Created by Apple on 07/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPlacesViewController1 : HHWTViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *describePlaceTF;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UIView *imgaeBackView;


@property NSMutableArray *tableArray;
@property NSMutableArray *imageArray;

@property NSString *index;
@property BOOL *fromVC;
@property BOOL *isSelected;
@end
