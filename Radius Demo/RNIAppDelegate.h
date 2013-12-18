//
//  RNIAppDelegate.h
//  Deesign
//
//  Created by David Helms on 10/30/13.
//  Copyright (c) 2013 David Helms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProximityKit/ProximityKit.h>

@interface RNIAppDelegate : UIResponder <UIApplicationDelegate, PKManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)processAction:(NSDictionary *)attributes;

@end
