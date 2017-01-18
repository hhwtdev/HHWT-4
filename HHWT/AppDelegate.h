//
//  AppDelegate.h
//  HHWT
//
//  Created by  kumar on 03/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#define showProgress(a)             [AppDelegate showProgressForState:a]

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *selectedTourDate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *visitedDate;

@property (nonatomic, retain) NSString *MapLatitude;
@property (nonatomic, retain) NSString *MapLongitude;

-(void)showProgress:(BOOL)staus;
+(void) showProgressForState:(BOOL)status;
+(BOOL)isEmpty:(id)thing;
@end

