//
//  ReviewFirstViewController.m
//  HHWT
//
//  Created by Dipin on 13/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ReviewFirstViewController.h"
#import "ExploredetailViewController.h"

@interface ReviewFirstViewController ()

@end

@implementation ReviewFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(popAlert) withObject:nil afterDelay:0.5];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.lblSeoul.frame.size.height - 1.1, self.lblSeoul.frame.size.width, 1.1f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.lblSeoul.layer addSublayer:bottomBorder];
    // Do any additional setup after loading the view.
}

- (void)popAlert
{
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Choose a city to review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
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

- (IBAction)actionSelect:(id)sender {
    
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.toReviewPage = @"YES";
   // fd.selectionID = SELECTION_THINGS;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}
@end
