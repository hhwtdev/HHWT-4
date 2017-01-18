//
//  FoodTableViewCell.h
//  HHWT
//
//  Created by  kumar on 05/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailModel.h"

@class ASStarRatingView;

@interface FoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndi;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblReview;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (retain, nonatomic) IBOutlet ASStarRatingView *starRatings;
-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath;

-(void)setDataListTour:(TourDetailModel *)tourModel index:(NSIndexPath *)indexPath;



@end
