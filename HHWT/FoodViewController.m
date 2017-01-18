//
//  FoodViewController.m
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodTableViewCell.h"
#import "AppDelegate.h"
#import "FoodDetailViewController.h"
#import "PopView.h"
#import "LocationViewController.h"
#import "FilterViewController.h"
#import "ReviewTableViewController.h"

@interface FoodViewController ()<UITableViewDataSource, UITableViewDelegate, PopViewDelegate, FilterDelegate>
{
    NSMutableData *mutableData;
    NSMutableArray *dataArray;
    NSMutableArray *originalData;
    NSMutableArray *activityArray;
    NSMutableArray *checkedStarValues;
    NSMutableArray *checkedActivities;
    UIColor *tintColor;
}
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyData;

@end

@implementation FoodViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    tintColor = [UIColor colorWithRed:50/255.0f green:204/255.0f blue:203/255.0f alpha:1.0f];

    [_btnFood setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnThingsToDo setTitleColor:tintColor forState:UIControlStateNormal];
    [_btnDeals setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _tableThingsDo.tableFooterView = [[UIView alloc] init];
    _tableFood.tableFooterView = [[UIView alloc] init];
    _tableDeals.tableFooterView = [[UIView alloc] init];
    
    
    _tableThingsDo.hidden = false;
    _tableFood.hidden = true;
    _tableThingsDo.hidden = true;

    _searchBaseView.hidden = YES;
    dataArray = [NSMutableArray array];
    originalData= [NSMutableArray array];
    activityArray = [[NSMutableArray alloc] init];
    checkedActivities = [[NSMutableArray alloc] init];
    checkedStarValues = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    [self prepareCategory];
        
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
//    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
   
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.btnFilter.frame.size.height - 1.1, self.btnFilter.frame.size.width, 1.1f);
    bottomBorder.backgroundColor = THEME_COLOR.CGColor;
    [self.btnFilter.layer addSublayer:bottomBorder];
    
    _gotoMap.layer.borderWidth = 1.0f;
    _gotoMap.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _gotoMap.layer.cornerRadius = 50/2;
    _gotoMap.layer.masksToBounds = YES;

    [_tableFood registerNib:[UINib nibWithNibName:@"FoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"foodCell"];

    
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
    
    // Do any additional setup after loading the view.
}

- (void)popAlert
{
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Choose a city to review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)prepareCategory
{
    NSString *selectionTitle;
    if(self.selectionID == SELECTION_FOOD1)
    {
        selectionTitle = @"Food";
    }else if(self.selectionID == SELECTION_PRAYER1)
    {
        selectionTitle = @"Prayer";
    }else if(self.selectionID == SELECTION_NEIGHBOURHOOD1)
    {
        selectionTitle = @"Neighbourhood";
    }else if(self.selectionID == SELECTION_THINGS1)
    {
        selectionTitle = @"Things to do";
    }
    _lblSelection.text = selectionTitle;
}
-(void)resetButton {
    
    [_btnFood setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnThingsToDo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDeals setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
-(void)searchAction
{
    if(_searchBaseView.hidden)
    {
        [_searchBar becomeFirstResponder];
        _searchBaseView.hidden =  NO;

    }else{
        [_searchBar resignFirstResponder];
        _searchBaseView.hidden =  YES;
    }
}

- (IBAction)btnSelectionAction:(UIButton *)sender {
    [self resetButton];
    switch (sender.tag) {
        case 1:
            _selectionID = SELECTION_THINGS1;
            [_btnThingsToDo setTitleColor:tintColor forState:UIControlStateNormal];

            break;
        case 2:
            _selectionID = SELECTION_FOOD1;
            [_btnFood setTitleColor:tintColor forState:UIControlStateNormal];

            break;
        case 3:
            [_btnDeals setTitleColor:tintColor forState:UIControlStateNormal];

            break;
            break;
        default:
            break;
    }
    
    if(sender.tag != 3){
        showProgress(YES);
        [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
    }
}

-(void)fetchData
{
    NSString *urlString;
    NSString *parameter;

    if(_isSearcSeoulActive == YES)
    {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/search.php"];
        parameter = [NSString stringWithFormat:@"searchvalue=%@&cityid=%@",_getSearchSeoulText,_cityID];
    }else{
        if([_getDistrict length] > 0)
        {
            urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_bydistrict.php"];
            parameter = [NSString stringWithFormat:@"cid=%d&district=%@&cityid=%@",_selectionID,_getDistrict,_cityID];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_new.php"];
            parameter = [NSString stringWithFormat:@"cid=%d&cityid=%@",_selectionID,_cityID];
        }
    }
    
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection )
    {
        mutableData = [[NSMutableData alloc] init];
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    showProgress(NO);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [dataArray removeAllObjects];
    [originalData removeAllObjects];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
    {
        _lblEmptyData.hidden = YES;
        dataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
        originalData = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
        [activityArray removeAllObjects];
        [checkedActivities removeAllObjects];
        for (NSDictionary *dict in originalData) {
            if (![activityArray containsObject:dict[@"activity"]]) {
                [activityArray addObject:dict[@"activity"]];
            }
        }
        [checkedActivities addObjectsFromArray:activityArray];
        
        if ([_toReviewPage isEqualToString:@"YES"]) {
            //[self performSelector:@selector(popAlert) withObject:nil afterDelay:0.5];
        }
        
    }else
    {
        _lblEmptyData.text = [jsonDict objectForKey:@"msg"];
        _lblEmptyData.hidden = NO;
    }
    [_tableFood reloadData];

    showProgress(NO);
}


#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    [cell setDataList:[dataArray objectAtIndex:indexPath.row] index:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    if ([_toReviewPage isEqualToString:@"YES"]) {
        ReviewTableViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewTableViewController"];
        fd.dataelement = dic;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else
    {
    showProgress(YES);
    
    FoodDetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodDetailViewController_STORYBOARD_ID];
    fd.selectionID = [[dic objectForKey:@"sno"] intValue];
    fd.getTripDic =_getTripDic;
    fd.selectionType = _selectionID;
    fd.selectedLocationDict = dic;
    fd.cityID = _cityID;
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
    showProgress(NO);
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar becomeFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    _searchBaseView.hidden = YES;
    
    [dataArray removeAllObjects];
    dataArray = [originalData mutableCopy];
    [_tableFood reloadData];
    
    if(dataArray.count == 0)
    {
        _lblEmptyData.text = @"No data available";
        _lblEmptyData.hidden = NO;
    }else{
        _lblEmptyData.hidden = YES;
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSMutableArray *filterArray = [NSMutableArray array];
    for(int i=0; i<originalData.count; i++)
    {
        NSDictionary *dic = [originalData objectAtIndex:i];
        NSString *getName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        NSString *searchText = [NSString stringWithFormat:@"%@",_searchBar.text];
        NSRange textRange = [[getName lowercaseString] rangeOfString:[searchText lowercaseString]];
        if(textRange.location != NSNotFound){
            [filterArray addObject:[originalData objectAtIndex:i]];
        }
    }
    [dataArray removeAllObjects];
    dataArray = filterArray;
    [_tableFood reloadData];
    
    if(dataArray.count == 0)
    {
        _lblEmptyData.text = @"No data available";
        _lblEmptyData.hidden = NO;
    }else{
        _lblEmptyData.hidden = YES;
    }
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filterAction:(UIButton *)button {
    if (activityArray.count  > 0 ) {
      [self performSegueWithIdentifier:@"toFilter" sender:nil];  
    }
    
//    PopView *fpPopView = [PopView loadNib];
//    [fpPopView loadData:@[@"5 Star", @"4 Star", @"3 Star",@"2 Star",@"1 Star", @"Cancel"]];
//    fpPopView.tag = 100;
//    [fpPopView setUPMenu];
//    fpPopView.delegate = self;
//    [fpPopView showMenuForView:button];
    
}

- (IBAction)switchCategory:(UIButton *)sender {
    PopView *fpPopView = [PopView loadNib];
    fpPopView.tag = 101;
    [fpPopView loadData:@[@"Things to do",@"Food & Drink",@"Prayer Spaces",@"Cancel"]];
    [fpPopView setUPMenu];
    fpPopView.delegate = self;
    [fpPopView showMenuForView:sender];
}

-(void)popViewDidDismiss:(PopView *)popView
{
}

-(void)popView:(PopView *)popView didSelectedAtIndex:(NSUInteger)selectedIndex
{
    if(popView.tag == 100)
    {
        if (selectedIndex == 5){
        }else{
            [self filterOperationStarts:(int)selectedIndex];
        }
    }else{
        switch (selectedIndex) {
//            case 0:
//                _selectionID = SELECTION_THINGS;
//                break;
//            case 1:
//                _selectionID = SELECTION_FOOD;
//                break;
//            case 2:
//                _selectionID = SELECTION_PRAYER;
//                break;
//            case 3:
//                _selectionID = SELECTION_NEIGHBOURHOOD;
                break;
            default:
                break;
        }
        
        [self prepareCategory];
        
        if(selectedIndex != 3){
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
    }
}

-(void)filterOperationStarts:(int)index
{
    float ratingValue = 0.0;
    if(index == 0)
        ratingValue = 5.0;
    else if(index == 1)
        ratingValue = 4.0;
    else if(index == 2)
        ratingValue = 3.0;
    else if(index == 3)
        ratingValue = 2.0;
    else if(index == 4)
        ratingValue = 1.0;
    else if(index == 5)
        return;
    
    NSMutableArray *filterArray = [NSMutableArray array];
    for(int i=0; i<originalData.count; i++)
    {
        NSDictionary *dic = [originalData objectAtIndex:i];
        if([[dic objectForKey:@"weight"] floatValue] == ratingValue || [[dic objectForKey:@"weight"] floatValue] == ratingValue + 0.5)
        {
            [filterArray addObject:[originalData objectAtIndex:i]];
        }
    }
    [dataArray removeAllObjects];
    dataArray = filterArray;
    [_tableFood reloadData];
    
    if(dataArray.count == 0)
    {
        _lblEmptyData.text = @"No data available";
        _lblEmptyData.hidden = NO;
    }else{
        _lblEmptyData.hidden = YES;
    }
}

-(void)filterOperationwithStars:(NSArray*)starArray
{
//    float ratingValue = 0.0;
//    if(index == 0)
//        ratingValue = 5.0;
//    else if(index == 1)
//        ratingValue = 4.0;
//    else if(index == 2)
//        ratingValue = 3.0;
//    else if(index == 3)
//        ratingValue = 2.0;
//    else if(index == 4)
//        ratingValue = 1.0;
//    else if(index == 5)
//        return;
    
}

- (IBAction)MapAction:(id)sender {
    LocationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:LOCATION_STORYBOARD_ID];
    exp.getData = originalData;
    exp.getTripDic =_getTripDic;
    exp.selectionType = _selectionID;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFilter"]) {
        FilterViewController *filter = (FilterViewController *)[segue destinationViewController];
        filter.activityArray = activityArray;
        filter.delegate = self;
        filter.checkedActivities = checkedActivities;
        filter.checkedStarValue = checkedStarValues;
    }
}

- (void)getSelectedFilters:(NSMutableArray *)starFillter withActivityFilter:(NSMutableArray *)activities
{
    
    NSCompoundPredicate *compoundStarPredicate;
    NSCompoundPredicate *compoundActivityPredicate;
    if (starFillter.count > 0) {
        NSMutableArray *predicates = [[NSMutableArray alloc] init];
        for (NSString *str in starFillter) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weight CONTAINS %@",str];
            [predicates addObject:predicate];
        }
        
        compoundStarPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
       
    }
    else
    {
        compoundStarPredicate = [[NSCompoundPredicate alloc] init];
    }
    if (activities.count > 0) {
        NSMutableArray *predicates = [[NSMutableArray alloc] init];
        for (NSString *str in activities) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"activity == %@",str];
            [predicates addObject:predicate];
        }        
        compoundActivityPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
    else
    {
        compoundActivityPredicate = [[NSCompoundPredicate alloc] init];
    }
    NSArray *compoundPredicates = @[compoundStarPredicate,compoundActivityPredicate];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:compoundPredicates];
    NSArray *filterArray = [originalData filteredArrayUsingPredicate:compoundPredicate];
    
    //    NSMutableArray *filterArray = [NSMutableArray array];
    //    for(int i=0; i<originalData.count; i++)
    //    {
    //        NSDictionary *dic = [originalData objectAtIndex:i];
    //        if([[dic objectForKey:@"weight"] floatValue] == ratingValue || [[dic objectForKey:@"weight"] floatValue] == ratingValue + 0.5)
    //        {
    //            [filterArray addObject:[originalData objectAtIndex:i]];
    //        }
    //    }
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:filterArray];
    [_tableFood reloadData];
    checkedStarValues = starFillter;
    checkedActivities = activities;

    if(dataArray.count == 0)
    {
        _lblEmptyData.text = @"No data available";
        _lblEmptyData.hidden = NO;
    }else{
        _lblEmptyData.hidden = YES;
    }
}
@end
