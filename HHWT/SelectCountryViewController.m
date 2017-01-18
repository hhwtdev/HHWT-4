//
//  SelectCountryViewController.m
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "SelectCountryViewController.h"

@interface SelectCountryViewController ()

@end

@implementation SelectCountryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentList = [[NSMutableArray alloc] initWithObjects:@"Singapore",@"Malaysia",@"Brunei",@"Indonesia",@"Thailand",@"UAE",@"India", nil];
    filteredContentList = [[NSMutableArray alloc] init];
    self.searchObj.delegate = self;
    self.searchTable.tableFooterView =[[UIView alloc]init];
    
    self.navigationController.navigationBarHidden = NO;
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Select Country";
    NSDictionary *attrDictterms = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:20.0],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    [self.navigationController.navigationBar setTitleTextAttributes:attrDictterms];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"Back";
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
    {
        return [filteredContentList count];
    }
    else
    {
        return [contentList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (isSearching)
    {
        cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [contentList objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearching)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[filteredContentList objectAtIndex:indexPath.row]] forKey:@"SELECTEDCOUNTRY"] ;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[contentList objectAtIndex:indexPath.row]] forKey:@"SELECTEDCOUNTRY"] ;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchTableList
{
    NSString *searchString = self.searchObj.text;
    for (NSString *tempStr in contentList)
    {
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame)
        {
            [filteredContentList addObject:tempStr];
        }
    }
    [self.searchTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [filteredContentList removeAllObjects];
    if([searchText length] != 0)
    {
        isSearching = YES;
        [self searchTableList];
    }
    else
    {
        isSearching = NO;
        [self.searchObj resignFirstResponder];
        [self.searchTable reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchObj resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [filteredContentList removeAllObjects];
    [self.searchObj resignFirstResponder];
    [self searchTableList];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


@end
