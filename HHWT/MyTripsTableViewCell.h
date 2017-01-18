//
//  MyTripsTableViewCell.h
//  HHWT
//
//  Created by sampath kumar on 13/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTripsTableViewCell;
@protocol MyTripsTableViewCellDelegate<NSObject>
-(void) btnDeleteTableViewCell:(UIButton *) button cell:(MyTripsTableViewCell*)cell;
@end

@interface MyTripsTableViewCell : UITableViewCell
@property(nonatomic, assign) id<MyTripsTableViewCellDelegate> delegate;
@property (nonatomic, assign) int indexVal;
@property (weak, nonatomic) IBOutlet UILabel *lblTripName;
@property (weak, nonatomic) IBOutlet UILabel *lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndictor;
@end
