//
//  GuideDetailsViewController.h
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideDetailsViewController : HHWTViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSDictionary *selectedCityDictionary;
@property (weak, nonatomic) NSDictionary *dictGuides;
- (IBAction)actionListPlaces:(id)sender;

@end
