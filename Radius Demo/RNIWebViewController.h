//
//  RNIWebViewController.h
//  Deesign
//
//  Created by David Helms on 10/30/13.
//  Copyright (c) 2013 David Helms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNIWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *theWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
