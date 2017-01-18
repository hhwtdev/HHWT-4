//
//  ThingstoDoTableViewCell.m
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ThingstoDoTableViewCell.h"
#import "ASStarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation ThingstoDoTableViewCell

-(void)setDataList:(NSDictionary *)dataDic index:(NSIndexPath *)indexPath
{
    NSArray *photosArray = (NSArray *)[dataDic objectForKey:@"photos"];
    NSString *imgURL;
    if(photosArray.count == 0)
        imgURL = @"";
    else
        imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
    
    self.activity.hidden = NO;
    [self.activity startAnimating];
    [self.imageViewThings sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.activity.hidden = YES;
        [self.activity stopAnimating];
    }];
    
//    if(indexPath.row % 2 == 0){
//        self.backgroundColor = [UIColor colorWithRed:253/255.0f green:248/255.0f blue:242/255.0f alpha:1.0];
//    }else{
//        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:224/255.0f blue:215/255.0f alpha:1.0];
//    }
    
    self.title.text = [dataDic objectForKey:@"name"];
    self.lblRating.text = [dataDic objectForKey:@"rating"];
    self.lblCountry.text = [dataDic objectForKey:@"activity"];
    self.lblPlace.text = [NSString stringWithFormat:@"%@ nearby food places", [dataDic objectForKey:@"foodc"]];
    self.lblFood.text = [NSString stringWithFormat:@"%@ prayer space nearby", [dataDic objectForKey:@"prayerc"]];
    self.starRating.canEdit = NO;
    self.starRating.maxRating = 5;
    self.starRating.rating = [[dataDic objectForKey:@"rating"] floatValue];
    
    NSString *toursNumber =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"tours"]];
    if (![toursNumber isEqualToString:@"0"])
    {
        if (![toursNumber isEqualToString:@"1"])
        {
            self.lblSpecialDeals.hidden = FALSE;
            self.lblSpecialDeals.text = [NSString stringWithFormat:@"%@ Special Deals Available >", [dataDic objectForKey:@"tours"]];
        }
        else
        {
            self.lblSpecialDeals.hidden = FALSE;
            self.lblSpecialDeals.text = [NSString stringWithFormat:@"%@ Special Deal Available >", [dataDic objectForKey:@"tours"]];
        }
    }
    else
    {
        self.lblSpecialDeals.hidden = TRUE;
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
