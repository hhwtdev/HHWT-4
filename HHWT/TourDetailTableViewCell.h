//
//  TourDetailTableViewCell.h
//  HHWT
//
//  Created by SampathKumar on 01/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface TourDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *lblDollar;
@property (weak, nonatomic) IBOutlet UILabel *lblDollarFomatt;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblRatings;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingsView;

@end
