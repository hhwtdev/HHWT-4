//
//  AddTripViewController.h
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ADD_TRIP_STORYBOARD_ID @"AddTripViewControllerSBID"

@interface AddTripViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (nonatomic, retain) NSString *elementID;
@end
