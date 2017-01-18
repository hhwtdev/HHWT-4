//
//  PopView.m
//  MyPopOverExample
//
//  Created by Velmurugan on 06/12/15.
//  Copyright © 2015 Velmurugan. All rights reserved.
//

#import "PopView.h"
#import "FPPopOverCell.h"
#import "AppDelegate.h"


//border color
//[UIColor blackColor]

//border width
#define kBorderWidth 1.f

//Row Height
#define kCellHeight 40.0

//Row Height
#define kPopOverWidth 150.0

#define kDummySpace 5
@interface PopView()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tabelView;
    NSArray *dataStringsArray;
    UIView *transperantView;
    UITapGestureRecognizer *tapGesture;
}
@end
@implementation PopView
+(PopView *)loadNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
}
-(void)setUPMenu
{
    [tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([FPPopOverCell class]) bundle:nil] forCellReuseIdentifier:kFPPopOverCellRUID];
}

-(void)showMenuForView:(UIView *)toView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    
    [self makeTransparentView];
    [topView addSubview:transperantView];
    
    //    CGRect topRect = [topView convertRect:toView.frame fromView:toView];
    //    self.frame = CGRectMake(topRect.origin.x, topRect.origin.y,100,100);
    
    //Get a Center of the button.
    CGPoint center = CGPointMake(CGRectGetMidX(toView.bounds), CGRectGetMidY(toView.bounds));
    
    //Get the Top point where need to show the view.
    CGPoint topPoint = [topView convertPoint:center fromView:toView];
    
    CGFloat requiredHeight = kCellHeight * dataStringsArray.count;
    
    CGRect neededRect = CGRectMake(topPoint.x-center.x, topPoint.y, self.isCategoryPopup == YES ?  appDelegate.window.frame.size.width - 30.0 : kPopOverWidth, self.isCategoryPopup == YES ? appDelegate.window.frame.size.height - 400 : requiredHeight);
    
    if(_isCountryPopUp)
        neededRect = _rectCountry;
    
    
    //Show keywords in Popup while enter a text in name field (CreateFanpage), self.isCategoryPopup == YES will enabled the tableview scroll set here...
    BOOL hasToDisableTheScroll = self.isCategoryPopup ? NO : YES;
    
    
    CGRect animationBeginRect =neededRect ;
    
    //Calculation Process
    CGSize screenRect = [self screenSize];
    if ((screenRect.height/2)<neededRect.origin.y) {
        //Screen In bottom, Need To move Up the popup
        if (screenRect.height>(neededRect.origin.y+center.y+neededRect.size.height)) {
            //Can Show Bellow Itself. No problem to show.
            neededRect.origin.y +=center.y;
        }
        else
        {
            //Problem to show bellow the Current Mode. So need to show above the View.
            neededRect.origin.y -=center.y;
            neededRect.size.height =-neededRect.size.height;
        }
    }
    else
    {
        //Screen in above half screen, Need to move down the popup
        neededRect.origin.y +=center.y;
    }
    
    CGFloat totalSpace = neededRect.origin.x+neededRect.size.width;
    if (totalSpace>screenRect.width) {
        //It will move over the Screen.
        totalSpace -= screenRect.width;
        neededRect.origin.x -= (totalSpace+kDummySpace);
    }
    
    animationBeginRect = CGRectMake(neededRect.origin.x, neededRect.origin.y, neededRect.size.width, 0);
    self.frame = animationBeginRect;
    
    
    [tabelView setScrollEnabled:!hasToDisableTheScroll];
    
    //Draw Border
    self.layer.borderWidth = kBorderWidth;
    self.layer.borderColor = THEME_COLOR.CGColor;
    
    //Add self to the View
    [topView addSubview:self];
    [tabelView reloadData];
    
    
    if(!self.isCategoryPopup){
        [UIView animateWithDuration:.3 animations:^{
            self.frame = neededRect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformIdentity;
                } completion:nil];
            }];
        }];
    }else{
        self.frame = neededRect;
    }
    
    //Gradient Layer if needed.
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = self.bounds;
    //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor fbColorWithHexString:@"40ACEA"] CGColor], nil];
    //    [self.layer insertSublayer:gradient atIndex:0];
    
}

-(void)loadData:(NSArray*)data
{
    dataStringsArray = [data copy];
}

-(void)updateData:(NSArray*)data
{
    dataStringsArray = [data copy];
    [tabelView reloadData];
}


#pragma mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataStringsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPPopOverCell *cell = [tableView dequeueReusableCellWithIdentifier:kFPPopOverCellRUID];
    if (!cell) {
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPPopOverCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.titleLabel.text = dataStringsArray[indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    return cell;
}
#pragma mark - TabelView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didSelectedAtIndex:)]) {
        [self.delegate popView:self didSelectedAtIndex:indexPath.row];
    }
    [self removePopUP];
}

#pragma mark - Private Methods
-(void)makeTransparentView
{
    transperantView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    transperantView.alpha=(!self.isCategoryPopup) ? 0.3 : 1.0;
    transperantView.backgroundColor = (!self.isCategoryPopup) ? [UIColor grayColor] : [UIColor clearColor];
    transperantView.userInteractionEnabled = YES;
    [self makeTapGesture];
    [transperantView addGestureRecognizer:tapGesture];
}

-(void)makeTapGesture{
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
}
#pragma mark - TapGesture Action
-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    //Dismiss Code.
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
        [self.delegate popViewDidDismiss:self];
    }
    [self removePopUP];
}

-(void)removePopUP
{
    if(!self.isCategoryPopup){
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            if (finished) {
                [self resetData];
            }
        }];
    }else{
        [self resetData];
    }
}

-(void)resetData{
    [self removeFromSuperview];
    [transperantView removeFromSuperview];
    [tapGesture removeTarget:self action:nil];
    tapGesture = nil;
    transperantView = nil;
    dataStringsArray = [[NSArray alloc] init];
    self.delegate = nil;
}

#pragma mark - Get Screen Size
- (CGSize) screenSize
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}


@end

