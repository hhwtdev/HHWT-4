//
//  FoodNewTableViewCell.m
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "FoodNewTableViewCell.h"
#import "ASStarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation FoodNewTableViewCell


-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath
{
    NSArray *photosArray = (NSArray *)[dataDic objectForKey:@"photos"];
    NSString *imgURL;
    if(photosArray.count == 0)
        imgURL = @"";
    else
        imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }];

    self.lbtTitle.text = [dataDic objectForKey:@"name"];
    self.lblCountry.text = [dataDic objectForKey:@"foodttags"];
    self.lblRatingLabel.text = [dataDic objectForKey:@"rating"];
    self.lblDetail.text = [dataDic objectForKey:@"foodctags"];
    self.starRating.canEdit = NO;
    self.starRating.maxRating = 5;
    self.starRating.rating = [[dataDic objectForKey:@"weight"] floatValue];
    
    NSString *toursNumber =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"tours"]];
    if (![toursNumber isEqualToString:@"0"])
    {
        if (![toursNumber isEqualToString:@"1"])
        {
            self.specialDealsImage.hidden = FALSE;
            self.specialDealsLabel.hidden = FALSE;
            self.specialDealsLabel.text = [NSString stringWithFormat:@"%@ Special Deals Available >", [dataDic objectForKey:@"tours"]];
        }
        else
        {
            self.specialDealsImage.hidden = FALSE;
            self.specialDealsLabel.hidden = FALSE;
            self.specialDealsLabel.text = [NSString stringWithFormat:@"%@ Special Deal Available >", [dataDic objectForKey:@"tours"]];
        }
    }
    else
    {
        self.specialDealsImage.hidden = TRUE;
        self.specialDealsLabel.hidden = TRUE;
    }

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
