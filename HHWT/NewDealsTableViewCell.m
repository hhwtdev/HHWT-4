//
//  NewDealsTableViewCell.m
//  HHWT
//
//  Created by Priya on 05/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "NewDealsTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation NewDealsTableViewCell

-(void)setDataListTour:(TourDetailModel *)tourModel index:(NSIndexPath *)indexPath {
    NSString *imgURL;
    if([tourModel.imgOne length] == 0)
        imgURL = @"";
    else
        imgURL = tourModel.imgOne;
    
  
    
    [self.imgViewDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    

    
    self.lblTitleDeals.text = tourModel.contentString;
    self.lblAmount.text = [NSString stringWithFormat:@"From %@ %@",tourModel.currency,tourModel.rateVal];
   
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
