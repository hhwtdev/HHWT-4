//
//  AppDelegate.m
//  HHWT
//
//  Created by  kumar on 03/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MBProgressHUD.h"
#import <Tapjoy/Tapjoy.h>


@interface AppDelegate ()
{
    MBProgressHUD *HUD;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];

    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectSuccess:)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectFail:)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
    
    //Turn on Tapjoy debug mode
    [Tapjoy setDebugEnabled:YES]; //Do not set this for any version of the game released to an app store
    
    //Tapjoy connect call
    [Tapjoy connect:@"IDbYfhuIR8SIDyidUWwqYwEBmbEorZKuc7gyZ6mHHYeA8P5LTlD7xItva9ok"];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

-(void)showProgress:(BOOL)staus{
    if (staus) {
        HUD.labelText = @"Loading...";
        [self.window addSubview:HUD];
        [HUD show:staus];
    }else{
        [HUD removeFromSuperview];
        [HUD hide:staus];
    }
}

+(void) showProgressForState:(BOOL)status{
    AppDelegate *appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDel showProgress:status];
}

+(BOOL)isEmpty:(id)thing {
    return thing == nil || [(NSString *)thing isKindOfClass:[NSNull class]] || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
    NSLog(@"Tapjoy connect Succeeded");
}

-(void)tjcConnectFail:(NSNotification*)notifyObj
{
    NSLog(@"Tapjoy connect Failed");
}

@end
