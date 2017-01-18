//

#import "important.h"
#import "TourDetailModel.h"'
#import "TourCheckAvailability.h"

@interface important ()
{
    
}


@end

@implementation important

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    _myTextView.layer.borderColor = borderColor.CGColor;
    _myTextView.layer.borderWidth = 1.0;
    _myTextView.layer.cornerRadius = 5.0;
    
    CGRect frame = _myTextView.frame;
    
    frame.size = _myTextView.contentSize;
    
    _myTextView.frame = frame;
    
}

- (IBAction)gotit:(id)sender {
    TourCheckAvailability *dis = [self.storyboard instantiateViewControllerWithIdentifier:tours];
    dis.selectedTour = _selectedTour;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
    
}


#pragma mark - UICollectionViewDataSource methods

@end