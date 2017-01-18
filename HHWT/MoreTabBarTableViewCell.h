//
//  MoreTabBarTableViewCell.h
//  HHWT
//
//  Created by SampathKumar on 25/10/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTabBarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthConstrint;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblHeightConstraintTitle;
@end
