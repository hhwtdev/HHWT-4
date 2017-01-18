//
//  SelectCountryViewController.h
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCountryViewController : UIViewController<UISearchBarDelegate>
{
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
    BOOL isSearching;
}
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchObj;

@end
