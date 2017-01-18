//
//  AddPlaceTableViewCell.h
//  HHWT
//
//  Created by Apple on 07/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPlaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *hoursLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl1;
@property (weak, nonatomic) IBOutlet UILabel *hoursLbl1;

@property NSString *listName;
@end
