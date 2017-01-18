//
//  AddPlacesViewController.h
//  
//
//  Created by sampath kumar on 26/03/16.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define ADD_PLACES_STORYBOARD_ID @"AddPlacesViewControllerSBID"

@interface AddPlacesViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPlaceName;
@property (weak, nonatomic) IBOutlet MKMapView *mapViw;

@property (weak, nonatomic) IBOutlet UIButton *btnPlace1;
@property (weak, nonatomic) IBOutlet UIButton *btnPlace2;
@property (weak, nonatomic) IBOutlet UIButton *btnPlace3;
@property (weak, nonatomic) IBOutlet UIButton *btnPlace4;

@property (weak, nonatomic) IBOutlet UIButton *btnFood;
@property (weak, nonatomic) IBOutlet UIButton *btnThings;
@property (weak, nonatomic) IBOutlet UIButton *btnPrayer;

- (IBAction)btnPlaceActions:(id)sender;

- (IBAction)foodAction:(id)sender;
- (IBAction)thingsAction:(id)sender;
- (IBAction)prayerAction:(id)sender;
- (IBAction)tapAction:(id)sender;

- (IBAction)tapMapViw:(id)sender;



- (IBAction)SubmitAction:(id)sender;


@end
