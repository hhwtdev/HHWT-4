//
//  VoteForCityTableViewCell.h
//  HHWT
//
//  Created by SampathKumar on 10/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoteForCityTableViewCellDelegate<NSObject>
- (void) tappedVote:(NSIndexPath *)path;
@end

@interface VoteForCityTableViewCell : UITableViewCell
@property (nonatomic, assign) id <VoteForCityTableViewCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPathVal;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnVote;
@end
