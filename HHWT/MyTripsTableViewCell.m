//
//  MyTripsTableViewCell.m
//  HHWT
//
//  Created by sampath kumar on 13/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "MyTripsTableViewCell.h"

@implementation MyTripsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)btnDeleteTapped:(UIButton *)button{
    button.selected=!button.selected;
    [self.delegate btnDeleteTableViewCell:button cell:self];
}

@end
