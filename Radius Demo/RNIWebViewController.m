//
//  RNIWebViewController.m
//  Deesign
//
//  Created by David Helms on 10/30/13.
//  Copyright (c) 2013 David Helms. All rights reserved.
//

#import "RNIWebViewController.h"

@implementation RNIWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    webView.hidden = FALSE;
    [self.activityIndicator stopAnimating];
    [UIView animateWithDuration: 0.50
                     animations:^{
                         webView.alpha = 0.0;
                         webView.alpha = 1.0;
                     }];
}

@end
