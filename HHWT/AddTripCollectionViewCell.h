//
//  AddTripCollectionViewCell.h
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTripCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstraint;

@end
