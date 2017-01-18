//
//  TripSummaryTableViewCell.m
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "TripSummaryTableViewCell.h"

@implementation TripSummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)btnDeleteTapped:(UIButton *)button{
    button.selected=!button.selected;
    [self.delegate btnDeleteTableViewCell:button cell:self];
}

-(IBAction)btnNotes:(UIButton *)button{
    button.selected=!button.selected;
    [self.delegate btnAddNotes:button cell:self];
}

@end
