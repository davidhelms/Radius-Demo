//
//  RNIAppDelegate.m
//  Deesign
//
//  Created by David Helms on 10/30/13.
//  Copyright (c) 2013 David Helms. All rights reserved.
//

#import "RNIAppDelegate.h"
#import "RNIViewController.h"
#import "RNIWebViewController.h"
#import "RNIImageViewController.h"


@implementation RNIAppDelegate
{
    PKManager *_pkManager;
    PKRegion *_pkRegion;
    void (^_fetchCompletion)(UIBackgroundFetchResult);
    
}

- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region
{
    NSLog(@"didEnter");
    NSInteger appState = [[UIApplication sharedApplication] applicationState];
    if (appState == UIApplicationStateActive) {
        
        _pkRegion = region;
        NSDictionary *alertInfo = region.attributes;
        UIAlertView *alert = [[UIAlertView alloc ]
                              initWithTitle:alertInfo[@"enterAlertTitleString"]
                              message: alertInfo[@"enterAlertBodyString"]
                              delegate:self
                              cancelButtonTitle:alertInfo[@"enterAlertCancelString"]
                              otherButtonTitles:alertInfo[@"enterAlertProceedString"], nil];
        [alert show];

        
    } else {

        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = region.attributes[@"enterNotificationBodyString"];
        notification.userInfo = region.attributes;
        notification.soundName = UILocalNotificationDefaultSoundName;
        _pkRegion = nil;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}


- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region
{
    NSLog(@"didExit");
    _pkRegion = region;
    NSInteger appState = [[UIApplication sharedApplication] applicationState];
    if (appState == UIApplicationStateActive) {
        
        _pkRegion = nil;
        NSDictionary *alertInfo = [region.attributes copy];
        UIAlertView *alert = [[UIAlertView alloc ]
                              initWithTitle:alertInfo[@"exitAlertTitleString"]
                              message: alertInfo[@"exitAlertBodyString"]
                              delegate:self
                              cancelButtonTitle:alertInfo[@"exitAlertCancelString"] otherButtonTitles:alertInfo[@"exitAlertProceedString"], nil];
        [alert show];
        
        
    } else {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = region.attributes[@"exitNotificationBodyString"];
        notification.userInfo = nil;
        notification.soundName = UILocalNotificationDefaultSoundName;
        _pkRegion = nil;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView clickedButtonAtIndex");
    if (_pkRegion) {
        NSLog(@"_pkRegion exists");
        NSLog(@"button index is %ld", (long)buttonIndex);
        switch (buttonIndex) {
            case 1:
            {
                [self processAction: _pkRegion.attributes];
                /*
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                RNIWebViewController *webViewController = (RNIWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
                self.window.rootViewController = webViewController;
                
                NSURL *theURL = [NSURL URLWithString:_pkRegion.attributes[@"urlString"]];
                NSURLRequest *theURLRequest = [NSURLRequest requestWithURL:theURL];
                [webViewController.theWebView loadRequest:theURLRequest];
                 */
                break;
            }
                
            default:
                break;
        }
    }
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
    
    if (notification.userInfo) {
        
        [self processAction: notification.userInfo];
/*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        RNIWebViewController *webViewController = (RNIWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        self.window.rootViewController = webViewController;
        NSLog(@"%@", notification.userInfo[@"urlString"]);
        NSURL *theURL = [NSURL URLWithString:notification.userInfo[@"urlString"]];
        NSURLRequest *theURLRequest = [NSURLRequest requestWithURL:theURL];
        [webViewController.theWebView loadRequest:theURLRequest];
 */
    }
    
}

- (void)processAction:(NSDictionary *)attributes
{
    if (attributes) {
        if ([attributes[@"actionType"] isEqualToString:@"web"]) {
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            RNIWebViewController *webViewController = (RNIWebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            self.window.rootViewController = webViewController;
            NSLog(@"%@", attributes[@"urlString"]);
            NSURL *theURL = [NSURL URLWithString:attributes[@"urlString"]];
            NSURLRequest *theURLRequest = [NSURLRequest requestWithURL:theURL];
            [webViewController.theWebView loadRequest:theURLRequest];
            
        } else if ([attributes[@"actionType"] isEqualToString:@"image"]) {
                
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            RNIImageViewController *imageViewController = (RNIImageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
            self.window.rootViewController = imageViewController;
            NSLog(@"%@", attributes[@"imageString"]);
            UIImage *theImage = [UIImage imageNamed:attributes[@"imageString"]];
            [imageViewController.imageView setImage:theImage];

        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"applicationDidFinishLaunchingWithOptions %@", launchOptions);
    
    // Register the preference defaults early.
    NSDictionary *defaults = [NSDictionary
                                 dictionaryWithObject:@"betterhomes"
                                 forKey:@"rootViewImage"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    NSLog(@"%@", [defaults objectForKey: @"rootViewImage"]);
    
    // Proximity Kit Manager will be used to notify of beacon and region changes
    if (!_pkManager) {
        _pkManager = [PKManager managerWithDelegate:self];
        NSLog(@"%@", [PKManager getVersion]);
        [_pkManager start];
    }


    
    // Set status bar style globally
    //UIApplication *theApplication = [UIApplication sharedApplication];
    //theApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    // Set the background fetch interval
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:3600];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"application performFetchWithCompletionHandler");
    // sync and always claim success until we can get some return value
    [_pkManager syncWithCompletionHandler: completionHandler];
    

}

- (void)proximityKitDidSync:(PKManager *)manager
{
    NSLog(@"proximityKitDidSync");
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
     NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
                                 
}

@end
