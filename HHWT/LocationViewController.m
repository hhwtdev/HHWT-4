//
//  LocationViewController.m
//  
//
//  Created by sampath kumar on 26/03/16.
//
//

#import "LocationViewController.h"
#import "AnnotationView.h"
#import "JPSThumbnailAnnotation.h"
#import "FoodDetailViewController.h"
#import "AppDelegate.h"

@interface LocationViewController ()<MKMapViewDelegate>{
    AppDelegate *appDel;
}

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDel = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *anotationArray = [NSMutableArray array];
    for(NSDictionary *dd in _getData)
    {
        NSString *lati = [dd objectForKey:@"latitude"];
        NSString *longi = [dd objectForKey:@"longitude"];
        CLLocationCoordinate2D centerCoordinate;
        centerCoordinate.latitude = [lati doubleValue];
        centerCoordinate.longitude = [longi doubleValue];
        
        MKCoordinateRegion region;
        CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:centerCoordinate
                                                           altitude:0
                                                 horizontalAccuracy:0
                                                   verticalAccuracy:0
                                                          timestamp:[NSDate date]];
        region.center = locObj.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.1;
        span.longitudeDelta = 0.1;
        region.span = span;
        [self.mapVie setRegion:region animated:YES];
        
        NSArray *photosArray = (NSArray *)[dd objectForKey:@"photos"];
        NSString *imgURL;
        if(photosArray.count == 0)
            imgURL = @"";
        else
            imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
        
        // Empire State Building
        JPSThumbnail *empire = [[JPSThumbnail alloc] init];
        empire.imageURL = imgURL;
        empire.title = [dd objectForKey:@"name"];
        empire.subtitle = [dd objectForKey:@"district"];
        empire.coordinate = centerCoordinate;
        empire.dataArray = [NSMutableArray array];
        [empire.dataArray addObject:dd];
        empire.disclosureBlock = ^{
        };
        [anotationArray addObject:[JPSThumbnailAnnotation annotationWithThumbnail:empire]];
    }
    [self.mapVie addAnnotations:[NSArray arrayWithArray:anotationArray]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recieveData:)
                                                 name:@"ArrowFire"
                                               object:nil];

    self.mapVie.showsUserLocation = YES;
}

-(void)recieveData:(NSNotification *) notification
{
    NSDictionary *dic = notification.userInfo;
    FoodDetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodDetailViewController_STORYBOARD_ID];
    fd.selectionID = [[dic objectForKey:@"sno"] intValue];
    fd.getTripDic =_getTripDic;
    fd.selectionType = _selectionType;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}



- (IBAction)tapAction:(UITapGestureRecognizer *)gesture {
    
    if(_getData.count == 0)
    {
        [self.mapVie removeAnnotations:[self.mapVie annotations]];
        
        CGPoint touchPoint = [gesture locationInView:self.mapVie];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapVie convertPoint:touchPoint toCoordinateFromView:self.mapVie];
        
        MKCoordinateRegion region;
        CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(touchMapCoordinate.latitude , touchMapCoordinate.longitude)
                                                           altitude:0
                                                 horizontalAccuracy:0
                                                   verticalAccuracy:0
                                                          timestamp:[NSDate date]];
        region.center = locObj.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta  = 1;
        span.longitudeDelta = 1;
        region.span = span;
        [self.mapVie setRegion:region animated:YES];
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = touchMapCoordinate;
        //[self getAddressFromLatLon:locObj];
        [self.mapVie addAnnotation:myAnnotation];
        
        appDel.MapLatitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
        appDel.MapLongitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
        
        [self performSelector:@selector(m1) withObject:nil afterDelay:1.5f];

    }
}

-(void)m1
{
    [[[UIAlertView alloc] initWithTitle:@"Info" message:@"Are you sure to add this location!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         
     }];
    
}


@end
