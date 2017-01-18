//
//  ViewAllViewController.m
//  HHWT
//
//  Created by SYZYGY on 29/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ViewAllViewController.h"

@interface ViewAllViewController ()

@end

@implementation ViewAllViewController

- (void)viewDidLoad
{
    self.viewAllTable.tableFooterView = [[UIView alloc] init];
    self.dealsViewAllTable.tableFooterView = [[UIView alloc] init];
    
    
    [self.dealsViewAllTable registerNib:[UINib nibWithNibName:@"NewDealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewDealsTableViewCell"];
    
    self.title =self.keyStr;
    NSLog(@"Datas %lu",(unsigned long)self.datasArr.count);
    
    if ([self.keyStr isEqualToString:@"Special"])
    {
        self.viewAllTable.hidden =TRUE;
        self.dealsViewAllTable.hidden =FALSE;
    }
    else
    {
        self.viewAllTable.hidden =FALSE;
        self.dealsViewAllTable.hidden =TRUE;
    }
    [super viewDidLoad];
}


#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.viewAllTable)
    {
        UITableViewCell *cell2 = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
        
        NSDictionary *dictFood = self.datasArr[indexPath.row];
        
        ASStarRatingView *imageThings1 = (ASStarRatingView *)[cell2 viewWithTag:50];
        imageThings1.canEdit = NO;
        imageThings1.maxRating = 5;
        imageThings1.rating = [[dictFood objectForKey:@"rating"] floatValue];
        
        UILabel *lblFoodTitle = (UILabel *)[cell2 viewWithTag:20];
        lblFoodTitle.text = [dictFood objectForKey:@"name"];
        UILabel *lblFoodTitle2 = (UILabel *)[cell2 viewWithTag:30];
        lblFoodTitle2.text = [dictFood objectForKey:@"activity"];
        UILabel *lblFoodTitle3 = (UILabel *)[cell2 viewWithTag:40];
        lblFoodTitle3.text = [dictFood objectForKey:@"rating"];
        UILabel *lblFoodTitle4 = (UILabel *)[cell2 viewWithTag:60];
        lblFoodTitle4.text = @"Within 500 meters";
        
        UIActivityIndicatorView *activityIndication = (UIActivityIndicatorView *)[cell2 viewWithTag:70];
        activityIndication.hidden = NO;
        [activityIndication startAnimating];
        
        NSArray *photosArray = (NSArray *)[dictFood objectForKey:@"photos"];
        NSString *imgURL;
        if(photosArray.count == 0)
            imgURL = @"";
        else
            imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];

        UIImageView *imageFood = (UIImageView *)[cell2 viewWithTag:10];
        [imageFood sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            activityIndication.hidden = YES;
            [activityIndication stopAnimating];
        }];
        return cell2;
    }
    else if (tableView == self.dealsViewAllTable)
    {
        NewDealsTableViewCell *cell3 = (NewDealsTableViewCell *)[self.dealsViewAllTable dequeueReusableCellWithIdentifier:@"NewDealsTableViewCell" forIndexPath:indexPath];
      
        NSDictionary *datas =[self.datasArr objectAtIndex:indexPath.row];
        cell3.lblTitleDeals.text = [NSString stringWithFormat:@"%@",[datas valueForKey:@"content"]];
        cell3.lblAmount.text = [NSString stringWithFormat:@"From %@ %@",[datas valueForKey:@"currency"],[datas valueForKey:@"rate"]];
        
        NSString *imgURL =[NSString stringWithFormat:@"%@",[datas valueForKey:@"image_one"]];
        [cell3.imgViewDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];

        
        return cell3;
        
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == self.viewAllTable)
    {
        return 120;
        
    }
    else if (tableView == self.dealsViewAllTable)
        return 130;
    
    return 0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
