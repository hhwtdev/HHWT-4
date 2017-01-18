//
//  ExploreViewController.h
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EXPLORE_STORYBOARD_ID @"ExploreViewControllerSBID"

@interface ExploreViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UICollectionView *exploreCollectionView;
@end
