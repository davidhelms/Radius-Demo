//
//  RNIViewController.m
//  Deesign
//
//  Created by David Helms on 10/30/13.
//  Copyright (c) 2013 David Helms. All rights reserved.
//

#import "RNIViewController.h"
#import "RNIWebViewController.h"

@interface RNIViewController ()

@end

@implementation RNIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImageView)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theImageName = [defaults objectForKey:@"rootViewImage"];
    NSLog(@"%@", theImageName);
    UIImage *theImage = [UIImage imageNamed:theImageName];
    [self.imageView setImage:theImage];
    [self.imageView setNeedsDisplay];
 
}

- (void)updateImageView
{
    NSLog(@"updateImageView");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theImageName = [defaults objectForKey:@"rootViewImage"];
    NSLog(@"%@", theImageName);
    UIImage *theImage = [UIImage imageNamed:theImageName];
    [self.imageView setImage:theImage];
    
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
