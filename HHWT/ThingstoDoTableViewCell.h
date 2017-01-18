//
//  ThingstoDoTableViewCell.h
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASStarRatingView;

@interface ThingstoDoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThings;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;
@property (weak, nonatomic) IBOutlet UILabel *lblFood;
@property (weak, nonatomic) IBOutlet ASStarRatingView *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialDeals;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;

-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath;
@end
