//
//  FoodViewController.h
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FoodViewController_STORYBOARD_ID @"FoodViewControllerSBID"


/* ENUM to handled the (UIView, UIlabel, UIbutton etc...)border positions here */
typedef NS_ENUM(int, SELECTION_ID1){
    SELECTION_FOOD1 = 1,
    SELECTION_PRAYER1,
    SELECTION_THINGS1,
    SELECTION_NEIGHBOURHOOD1,
};

@interface FoodViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UIButton *gotoMap;
@property (weak, nonatomic) IBOutlet UIView *searchBaseView;
- (IBAction)MapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UILabel *lblSelection;
@property (nonatomic, weak) IBOutlet UIButton *btnFilter;
@property (nonatomic, assign) int selectionID;
@property (nonatomic, retain) NSString *getDistrict;
@property (nonatomic, retain) NSString *cityID;
@property (nonatomic, assign) BOOL isSearcSeoulActive;
@property (nonatomic, retain) NSString *getSearchSeoulText;

@property (nonatomic, retain) NSString *toReviewPage;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;

@property (nonatomic, weak) IBOutlet UITableView *tableFood;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;
@property (weak, nonatomic) IBOutlet UITableView *tableDeals;

@property (weak, nonatomic) IBOutlet UITableView *tableThingsDo;
@property (weak, nonatomic) IBOutlet UIButton *btnThingsToDo;
@property (weak, nonatomic) IBOutlet UIButton *btnFood;
@property (weak, nonatomic) IBOutlet UIButton *btnDeals;
- (IBAction)btnSelectionAction:(UIButton *)sender;



- (IBAction)filterAction:(UIButton *)button;

@end
