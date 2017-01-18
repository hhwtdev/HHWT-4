//
//  LocationViewController.h
//  
//
//  Created by sampath kumar on 26/03/16.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define LOCATION_STORYBOARD_ID @"LocationViewControllerSBID"

@interface LocationViewController : HHWTViewController
@property (nonatomic, retain) NSMutableArray *getData;
@property (weak, nonatomic) IBOutlet MKMapView *mapVie;

@property (nonatomic, assign) int selectionType;
@property (nonatomic, retain) NSMutableDictionary *getTripDic;


- (IBAction)tapAction:(id)sender;

@end
