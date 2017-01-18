//
//  TripSummaryTableViewCell.h
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@class TripSummaryTableViewCell;

@protocol TripSummaryTableViewCellDelegate<NSObject>
-(void) btnDeleteTableViewCell:(UIButton *) button cell:(TripSummaryTableViewCell*)cell;
-(void) btnAddNotes:(UIButton *) button cell:(TripSummaryTableViewCell*)cell;
@end

@interface TripSummaryTableViewCell : UITableViewCell
@property(nonatomic, assign) id<TripSummaryTableViewCellDelegate> delegate;
@property (nonatomic, assign) int indexVal;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNotes;

@property (weak, nonatomic) IBOutlet UILabel *lblOpen;
@property (weak, nonatomic) IBOutlet UILabel *lblClose;
@property (weak, nonatomic) IBOutlet UILabel *lblFood;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@end
