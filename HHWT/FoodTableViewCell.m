//
//  FoodTableViewCell.m
//  HHWT
//
//  Created by  kumar on 05/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "FoodTableViewCell.h"
#import "ASStarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation FoodTableViewCell

-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath
{
    NSArray *photosArray = (NSArray *)[dataDic objectForKey:@"photos"];
    NSString *imgURL;
    if(photosArray.count == 0)
        imgURL = @"";
    else
        imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
        
    self.loadingIndi.hidden = NO;
    [self.loadingIndi startAnimating];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loadingIndi.hidden = YES;
        [self.loadingIndi stopAnimating];
    }];
    
    if(indexPath.row % 2 == 0){
        self.backgroundColor = [UIColor colorWithRed:253/255.0f green:248/255.0f blue:242/255.0f alpha:1.0];
    }else{
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:224/255.0f blue:215/255.0f alpha:1.0];
    }
    
    self.lblName.text = [dataDic objectForKey:@"name"];
    self.lblReview.text = [dataDic objectForKey:@"activity"];
    self.lblLocation.text = [dataDic objectForKey:@"foodctag"];
    
    self.starRatings.canEdit = NO;
    self.starRatings.maxRating = 5;
    self.starRatings.rating = [[dataDic objectForKey:@"weight"] floatValue];
}

-(void)setDataListTour:(TourDetailModel *)tourModel index:(NSIndexPath *)indexPath {
    NSString *imgURL;
    if([tourModel.imgOne length] == 0)
        imgURL = @"";
    else
        imgURL = tourModel.imgOne;
    
    self.loadingIndi.hidden = NO;
    [self.loadingIndi startAnimating];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loadingIndi.hidden = YES;
        [self.loadingIndi stopAnimating];
    }];
    
    if(indexPath.row % 2 == 0){
        self.backgroundColor = [UIColor colorWithRed:253/255.0f green:248/255.0f blue:242/255.0f alpha:1.0];
    }else{
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:224/255.0f blue:215/255.0f alpha:1.0];
    }
    
    self.lblName.text = tourModel.contentString;
    self.lblReview.text = [NSString stringWithFormat:@"%d Reviews",tourModel.totalReviews];
    self.lblLocation.text = [NSString stringWithFormat:@"From %@",tourModel.currency];
    self.starRatings.canEdit = NO;
    self.starRatings.maxRating = 5;
    self.starRatings.rating = tourModel.totalReviews;
}

@end
