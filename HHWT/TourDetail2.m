//
//  TourDetail2.m
//  HHWT
//
//  Created by SampathKumar on 07/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "TourDetail2.h"
#import "UIImageView+WebCache.h"
#import "TourCheckAvailability.h"
#import "FoodDetailCollectionViewCell.h"
#import "important.h"

@interface TourDetail2 () <UICollectionViewDelegate, UICollectionViewDelegate>
{
    NSMutableArray *photosArray;
}
@property (weak, nonatomic) IBOutlet UILabel *lblDollar;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblOverviews;
@property (weak, nonatomic) IBOutlet UILabel *lblDollarFormatt;
@property (weak, nonatomic) IBOutlet UICollectionView *collectonView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TourDetail2

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Tour Detail";
    photosArray = [NSMutableArray new];
    _lblDesc.text = _selectedTour.contentString;
    _lblOverviews.text = _selectedTour.overviews;
    _lblDollar.text = [NSString stringWithFormat:@"%@",_selectedTour.rateVal];
    _lblDollarFormatt.text = [NSString stringWithFormat:@"From %@",_selectedTour.currency];
    self.lbl1.text = [_selectedTour.contentString length] == 0 ? @"..." : _selectedTour.contentString;
    self.lblReview.text = @"43";
    self.ratingsView.rating = 3.0f;
    self.lblOverview.text = _selectedTour.overviews;
    self.lblHighlights.text = _selectedTour.highlights;
    self.lblWhatExpect.text = [_selectedTour.whatcanyouexpect length] == 0 ? @"..." : _selectedTour.whatcanyouexpect;
    self.lblLocation.text = _selectedTour.location;
    self.lblInclusion.text = _selectedTour.inclusionandexclusion;
    self.lblDepartPoint.text = _selectedTour.departurepoint;
    self.lblDepartDate.text = _selectedTour.departuredate;
    self.lblDepartTime.text = _selectedTour.departuretime;

    NSString *imgURL;
    
    
    if(_selectedTour.snoVal>10)
    {
        _checkbutton.text=@"Check Website";
        [_checksecond setTitle:@"Check Website" forState:UIControlStateNormal];

    }
    
    
    if([_selectedTour.imgOne length] == 0)
        imgURL = @"";
    else
        imgURL = _selectedTour.imgOne;
    
    if([_selectedTour.imgOne length]>0)
        [photosArray addObject:_selectedTour.imgOne];
    
    if([_selectedTour.imgTwo length]>0)
        [photosArray addObject:_selectedTour.imgTwo];
    
    if([_selectedTour.imgThree length]>0)
        [photosArray addObject:_selectedTour.imgThree];
    
    if([_selectedTour.imgFour length]>0)
        [photosArray addObject:_selectedTour.imgFour];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 204);
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectonView setPagingEnabled:YES];
    [self.collectonView setCollectionViewLayout:flowLayout];
    self.pageControl.numberOfPages = photosArray.count;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectonView.frame.size.width;
    self.pageControl.currentPage = self.collectonView.contentOffset.x / pageWidth;
}

- (IBAction)saveAction:(id)sender {
    
    
    NSArray *currencies = @[[_selectedTour.contentString length] == 0 ? @"..." : _selectedTour.contentString,_selectedTour.website];
    
    NSLog(@"%@", currencies);
    

    NSArray* sharedObjects=[NSArray arrayWithObjects:@"sharecontent", [_selectedTour.contentString length] == 0 ? @"..." : _selectedTour.contentString, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:currencies applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];

    
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FoodDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    NSString *imgURL;
    if(photosArray.count>0)
        imgURL= [photosArray objectAtIndex:indexPath.row];
    else
        imgURL = @"";
    
    cell.loadingIndi.hidden = NO;
    [cell.loadingIndi startAnimating];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.loadingIndi.hidden = YES;
        [cell.loadingIndi stopAnimating];
    }];
    return cell;
}

- (IBAction)checkAvailabilityActon:(id)sender {
    
    if(_selectedTour.snoVal<11)
    {
    /*
    TourCheckAvailability *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_CHECK_STORYBOARD_ID];
    dis.selectedTour = _selectedTour;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
     
    */
       
        important *dis = [self.storyboard instantiateViewControllerWithIdentifier:govinddec];
        dis.selectedTour = _selectedTour;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
    
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_selectedTour.website]];

    }
}

- (IBAction)checkavail:(id)sender {
    if(_selectedTour.snoVal<11)
    {
        
        /*
        TourCheckAvailability *dis = [self.storyboard instantiateViewControllerWithIdentifier:govinddec];
        dis.selectedTour = _selectedTour;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
        */
        important *dis = [self.storyboard instantiateViewControllerWithIdentifier:govinddec];
        dis.selectedTour = _selectedTour;

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
        
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_selectedTour.website]];
        
    }
    
}

- (IBAction)pricebuttonclick:(id)sender {
    
    if(_selectedTour.snoVal<11)
    {
        
        /*
         TourCheckAvailability *dis = [self.storyboard instantiateViewControllerWithIdentifier:govinddec];
         dis.selectedTour = _selectedTour;
         if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
         [self showViewController:dis sender:nil];
         }else{
         [self.navigationController pushViewController:dis animated:YES];
         }
         */
        important *dis = [self.storyboard instantiateViewControllerWithIdentifier:govinddec];
        dis.selectedTour = _selectedTour;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
        
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_selectedTour.website]];
        
    }
    
    
}



@end
