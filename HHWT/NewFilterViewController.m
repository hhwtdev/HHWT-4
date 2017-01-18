//
//  NewFilterViewController.m
//  HHWT
//
//  Created by Priya on 05/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "NewFilterViewController.h"

@interface NewFilterViewController ()

{
    NSArray *categoriesArray;
    NSArray *thingstodoArray;
    NSArray *filterArray;
    NSMutableArray *arrSelectedCategory;
    NSMutableArray *arrSelectedFoods;
    int selectedStar;
    NSMutableData *mutableData;
    NSArray *dataArray;
    NSMutableArray *originalData;
    NSMutableArray *activityArray;
    NSMutableArray *checkedActivities;
    NSMutableArray *checkedStarValues;
}

@end

@implementation NewFilterViewController

- (void)viewDidLoad {
    exit(0);
    
    self.title = @"Filter";
    [super viewDidLoad];
    
    _tableViewFilter.tableFooterView = [[UIView alloc] init];
    
    mutableData = [[NSMutableData alloc] init];
    dataArray = [NSMutableArray array];
    originalData= [NSMutableArray array];
    activityArray = [[NSMutableArray alloc] init];
    checkedActivities = [[NSMutableArray alloc] init];
    checkedStarValues = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    categoriesArray =[[NSArray alloc] initWithObjects:@"Korean", @"Western", @"Fusion", @"Cafe", @"Others", nil];
    thingstodoArray=[[NSArray alloc] initWithObjects:@"Amusement Parks", @"Landmark", @"Musuems", @"Nature & Parks", @"Outdoor Activities",@"Sights & Landmarks",@"Shopping",@"Traveller Resources",@"Transportation",@"Theatre & Concerts",@"Zoo & Aquariums",@"Others", nil];
     filterArray =[[NSArray alloc] initWithObjects:@"Halal Certified", @"Halal Meat", @"Vegetarian", @"Muslim Owned", @"Seafood", nil];
    arrSelectedCategory = [[NSMutableArray alloc] init];
    arrSelectedFoods = [[NSMutableArray alloc] init];
    
    if (_selectedIndex == 1) {
        _imageviewTitle.image = [UIImage imageNamed:@"Thingstodothirdpageselect.png"];
    
    }
    else
        _imageviewTitle.image = [UIImage imageNamed:@"foodanddrinks.png"];
    
    
    _tableViewFilter.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_selectedIndex == 1) {
        return 2;
    }
    else
         return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    else
    {
        return 50;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (_selectedIndex == 2) {
        if (section == 0){
            return 1;
        }
        
        else if (section == 1)
            return categoriesArray.count;
        else{
            return filterArray.count;
        }

    }
    else{
    if (section == 0){
        return 1;
    }
    
        else if (section == 1)
        return thingstodoArray.count;
       }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    
    if (indexPath.section == 0){
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RatingCell" forIndexPath:indexPath];
        UIButton *btnAny = (UIButton *)[cell viewWithTag:1];
        btnAny.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0];
        btnAny.layer.cornerRadius = 5.0;
        [btnAny setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAny addTarget:self action:@selector(actionAny:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnTwo = (UIButton *)[cell viewWithTag:5];
        [btnTwo addTarget:self action:@selector(actionTwo:) forControlEvents:UIControlEventTouchUpInside];
       
        
        
        UIButton *btnThree = (UIButton *)[cell viewWithTag:8];
        [btnThree addTarget:self action:@selector(actionThree:) forControlEvents:UIControlEventTouchUpInside];
       
        
       // UIView *viewFour = (UIView *)[cell viewWithTag:10];
        UIButton *btnFour = (UIButton *)[cell viewWithTag:13];
        [btnFour addTarget:self action:@selector(actionFour:) forControlEvents:UIControlEventTouchUpInside];
       // UILabel *lblFour = (UILabel *)[cell viewWithTag:11];
       // UIImageView *imgViewFour = (UIImageView *)[cell viewWithTag:12];
        
        return cell;
        
    }
    
    else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
        UIImageView *imgViewSelection = (UIImageView *)[cell viewWithTag:20];
        imgViewSelection.image = [UIImage imageNamed:@"tick.png"];
        
        if (indexPath.section == 1) {
            lblTitle.text = [thingstodoArray objectAtIndex:indexPath.row];
        }else{
        lblTitle.text = [filterArray objectAtIndex:indexPath.row];
        }
        
               return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *img = (UIImageView *)[cell viewWithTag:20];
        img.image = [UIImage imageNamed:@"selectedtick.png"];
        
        [arrSelectedCategory addObject:[NSString stringWithFormat:@"'%@'",[thingstodoArray objectAtIndex:indexPath.row]]];
        
       NSString *str = [arrSelectedCategory componentsJoinedByString:@","];
        NSLog(@"append = %@",str);
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *img = (UIImageView *)[cell viewWithTag:20];
        img.image = [UIImage imageNamed:@"selectedtick.png"];
        [arrSelectedFoods addObject:[NSString stringWithFormat:@"'%@'",[categoriesArray objectAtIndex:indexPath.row]]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_selectedIndex == 1) {
        if (section == 0){
            return @"Minimum Rating";
        }
        
        else if (section == 1)
            return @"Categories";
    }
    else{
        if (section == 0){
            return @"Minimum Rating";
        }
        
        else if (section == 1)
            return @"Categories";
        else if (section == 2)
            return @"Food Classifications";
    }
    
    return nil;
}


- (IBAction)actionClearAll:(id)sender {
    
    [_tableViewFilter reloadData];
}

- (IBAction)actionApply:(id)sender {
    [ self performSelector:@selector(fetchData) withObject:nil afterDelay:0.25];
}

- (IBAction)actionAny:(id)sender
{
    selectedStar = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell =  (UITableViewCell *)[_tableViewFilter cellForRowAtIndexPath:indexPath];
    UIButton *btnAny = (UIButton *)[cell viewWithTag:1];
    btnAny.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0];
    btnAny.layer.cornerRadius = 5.0;
    [btnAny setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAny addTarget:self action:@selector(actionAny:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewTwo = (UIView *)[cell viewWithTag:2];
    viewTwo.backgroundColor = [UIColor clearColor];
    viewTwo.layer.cornerRadius = 0;
    UILabel *lblTwo = (UILabel *)[cell viewWithTag:3];
    lblTwo.textColor = [UIColor blackColor];
    UIImageView *imgViewTwo = (UIImageView *)[cell viewWithTag:4];
    
    
    UILabel *lblThree = (UILabel *)[cell viewWithTag:7];
    UIView *viewThree = (UIView *)[cell viewWithTag:6];
    UIImageView *imgViewThree = (UIImageView *)[cell viewWithTag:9];
    viewThree.backgroundColor = [UIColor clearColor];
    viewThree.layer.cornerRadius = 0;
    lblThree.textColor = [UIColor blackColor];


    
    UIView *viewFour = (UIView *)[cell viewWithTag:10];
    UILabel *lblFour = (UILabel *)[cell viewWithTag:11];
    UIImageView *imgViewFour = (UIImageView *)[cell viewWithTag:12];
    viewFour.backgroundColor = [UIColor clearColor];
    viewFour.layer.cornerRadius = 0;
    lblFour.textColor = [UIColor blackColor];
    
    
    }
- (IBAction)actionTwo:(id)sender
{
    selectedStar = 2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell =  (UITableViewCell *)[_tableViewFilter cellForRowAtIndexPath:indexPath];
    UIButton *btnAny = (UIButton *)[cell viewWithTag:1];
    btnAny.backgroundColor = [UIColor clearColor];
    [btnAny setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
    
    
    UIView *viewTwo = (UIView *)[cell viewWithTag:2];
    viewTwo.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0];
    viewTwo.layer.cornerRadius = 5.0;
    UILabel *lblTwo = (UILabel *)[cell viewWithTag:3];
    lblTwo.textColor = [UIColor whiteColor];
    UIImageView *imgViewTwo = (UIImageView *)[cell viewWithTag:4];
    
    
    UILabel *lblThree = (UILabel *)[cell viewWithTag:7];
    UIView *viewThree = (UIView *)[cell viewWithTag:6];
    UIImageView *imgViewThree = (UIImageView *)[cell viewWithTag:9];
    viewThree.backgroundColor = [UIColor clearColor];
    viewThree.layer.cornerRadius = 0;
    lblThree.textColor = [UIColor blackColor];
    
    
    
    UIView *viewFour = (UIView *)[cell viewWithTag:10];
    UILabel *lblFour = (UILabel *)[cell viewWithTag:11];
    UIImageView *imgViewFour = (UIImageView *)[cell viewWithTag:12];
    viewFour.backgroundColor = [UIColor clearColor];
    viewFour.layer.cornerRadius = 0;
    lblFour.textColor = [UIColor blackColor];

}

- (IBAction)actionThree:(id)sender
{
    selectedStar = 3;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell =  (UITableViewCell *)[_tableViewFilter cellForRowAtIndexPath:indexPath];
    UIButton *btnAny = (UIButton *)[cell viewWithTag:1];
    btnAny.backgroundColor = [UIColor clearColor];
    [btnAny setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    UIView *viewTwo = (UIView *)[cell viewWithTag:2];
    viewTwo.backgroundColor = [UIColor clearColor];
    viewTwo.layer.cornerRadius = 0;
    UILabel *lblTwo = (UILabel *)[cell viewWithTag:3];
    lblTwo.textColor = [UIColor blackColor];
    UIImageView *imgViewTwo = (UIImageView *)[cell viewWithTag:4];
    
    
    UILabel *lblThree = (UILabel *)[cell viewWithTag:7];
    UIView *viewThree = (UIView *)[cell viewWithTag:6];
    UIImageView *imgViewThree = (UIImageView *)[cell viewWithTag:9];
    viewThree.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0];
    viewThree.layer.cornerRadius = 5.0;
    lblThree.textColor = [UIColor whiteColor];
    
    
    
    UIView *viewFour = (UIView *)[cell viewWithTag:10];
    UILabel *lblFour = (UILabel *)[cell viewWithTag:11];
    UIImageView *imgViewFour = (UIImageView *)[cell viewWithTag:12];
    viewFour.backgroundColor = [UIColor clearColor];
    viewFour.layer.cornerRadius = 0;
    lblFour.textColor = [UIColor blackColor];

}

- (IBAction)actionFour:(id)sender
{
    selectedStar = 4;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell =  (UITableViewCell *)[_tableViewFilter cellForRowAtIndexPath:indexPath];
    UIButton *btnAny = (UIButton *)[cell viewWithTag:1];
    btnAny.backgroundColor = [UIColor clearColor];
    [btnAny setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    UIView *viewTwo = (UIView *)[cell viewWithTag:2];
    viewTwo.backgroundColor = [UIColor clearColor];
    viewTwo.layer.cornerRadius = 0;
    UILabel *lblTwo = (UILabel *)[cell viewWithTag:3];
    lblTwo.textColor = [UIColor blackColor];
    UIImageView *imgViewTwo = (UIImageView *)[cell viewWithTag:4];
    
    
    UILabel *lblThree = (UILabel *)[cell viewWithTag:7];
    UIView *viewThree = (UIView *)[cell viewWithTag:6];
    UIImageView *imgViewThree = (UIImageView *)[cell viewWithTag:9];
    viewThree.backgroundColor = [UIColor clearColor];
    viewThree.layer.cornerRadius = 0;
    lblThree.textColor = [UIColor blackColor];
    
    
    
    UIView *viewFour = (UIView *)[cell viewWithTag:10];
    UILabel *lblFour = (UILabel *)[cell viewWithTag:11];
    UIImageView *imgViewFour = (UIImageView *)[cell viewWithTag:12];
    viewFour.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0];
    viewFour.layer.cornerRadius = 5.0;
    lblFour.textColor = [UIColor whiteColor];

}


-(void)fetchData
{
    NSString *urlString;
    NSString *parameter;
    
                urlString = [NSString stringWithFormat:@"www.hhwt.tech/hhwt_webservice/folder/filterresult.php"];
    NSString *strFilter;
    if (arrSelectedFoods.count == 0) {
       strFilter = @"0";
    }
    else
    {
        strFilter = [arrSelectedFoods componentsJoinedByString:@","];
    }
    
    NSString *strCategory;
    if (arrSelectedCategory.count == 0) {
        strCategory = @"0";
    }
    else
    {
        strCategory = [arrSelectedCategory componentsJoinedByString:@","];
    }

    parameter = [NSString stringWithFormat:@"cid=%d&cityid=%@&rating=%d&foodc=%@&foodt=%@",_selectionID,_cityID,selectedStar,strFilter,strCategory];
    
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
   // [originalData removeAllObjects];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    
        if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
        {
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
            
           
            
        }else
        {
           
        }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyFilter" object:dataArray];
        
    showProgress(NO);
}

@end
