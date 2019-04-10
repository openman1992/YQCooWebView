//
//  YQCooViewController.m
//  YQCooWebView
//
//  Created by openman1992 on 04/04/2019.
//  Copyright (c) 2019 openman1992. All rights reserved.
//

#import "YQCooViewController.h"
#import "YQCooWebViewController.h"

@interface YQCooViewController ()

@end

@implementation YQCooViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UINavigationController *nav = [YQCooWebViewController instanceWithUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    nav.toolbarHidden = NO;
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
