//
//  NewDealsTableViewCell.h
//  HHWT
//
//  Created by Priya on 05/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"

@interface NewDealsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDeals;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleDeals;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

-(void)setDataListTour:(TourDetailModel *)tourModel index:(NSIndexPath *)indexPath;

@end
