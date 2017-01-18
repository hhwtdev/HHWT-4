//
//  FoodNewTableViewCell.h
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASStarRatingView;

@interface FoodNewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbtTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet ASStarRatingView *starRating;
@property (weak, nonatomic) IBOutlet UILabel *specialDealsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *specialDealsImage;

-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath;

@end
