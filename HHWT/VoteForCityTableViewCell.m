//
//  VoteForCityTableViewCell.m
//  HHWT
//
//  Created by SampathKumar on 10/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "VoteForCityTableViewCell.h"

@implementation VoteForCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)voteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tappedVote:)]) {
        [self.delegate tappedVote:self.indexPathVal];
    }

}

@end
