//
//  JPSThumbnail.h
//  JPSThumbnailAnnotation
//
//  Created by Jean-Pierre Simard on 4/22/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef void (^ActionBlock)();

@interface JPSThumbnail : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) ActionBlock disclosureBlock;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end