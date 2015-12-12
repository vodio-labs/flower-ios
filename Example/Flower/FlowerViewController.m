//
//  FlowerViewController.m
//  Flower
//
//  Created by Nir Ninio on 12/10/2015.
//  Copyright (c) 2015 Nir Ninio. All rights reserved.
//

#import "FlowerViewController.h"
#import "FlowerTester.h"

@interface FlowerViewController ()

@end

@implementation FlowerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlowerTester test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
