//
//  ExploredetailViewController.h
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FoodViewController_STORYBOARD_ID @"FoodViewControllerSBID"

/* ENUM to handled the (UIView, UIlabel, UIbutton etc...)border positions here */
typedef NS_ENUM(int, SELECTION_ID){
    SELECTION_FOOD = 1,
    SELECTION_PRAYER,
    SELECTION_THINGS,
    SELECTION_NEIGHBOURHOOD,
};


@interface ExploredetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    UIScrollView *scroll;
}
@property (nonatomic, assign) CGFloat lastContentOffsetXval;
@property (nonatomic, assign) CGFloat lastContentOffsetYval;


@property (nonatomic, assign) int selectionID;
@property (nonatomic, retain) NSString *getDistrict;
@property (nonatomic, retain) NSString *cityID;
@property (nonatomic, assign) BOOL isSearcSeoulActive;
@property (nonatomic, retain) NSString *getSearchSeoulText;

@property (nonatomic, retain) NSString *toReviewPage;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyData;


@property (weak, nonatomic) IBOutlet UIButton *btnThings;
- (IBAction)actionThings:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFoods;
- (IBAction)actionFoods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDeals;
- (IBAction)actionDeals:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableThings;
@property (weak, nonatomic) IBOutlet UITableView *tablenewDeals;
@property (weak, nonatomic) IBOutlet UITableView *tableFoods;


@property (strong, nonatomic) IBOutlet UIView *viewThings;
@property (strong, nonatomic) IBOutlet UIView *viewFood;
@property (strong, nonatomic) IBOutlet UIView *viewDeals;
@property (weak, nonatomic) IBOutlet UIView *tabView;

@end
