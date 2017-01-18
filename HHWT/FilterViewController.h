//
//  FilterViewController.h
//  HHWT
//
//  Created by Dipin on 19/05/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterDelegate <NSObject>

- (void)getSelectedFilters:(NSMutableArray *)starFillter withActivityFilter:(NSMutableArray *)activities;

@end

@interface FilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, strong) NSMutableArray *checkedStarValue;
@property (nonatomic, strong) NSMutableArray *checkedActivities;
@property (nonatomic, weak) id<FilterDelegate> delegate;
- (IBAction)actionSave:(id)sender;

@end
