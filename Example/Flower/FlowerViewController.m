//
//  FlowerViewController.m
//  Flower
//
//  Created by Nir Ninio on 12/10/2015.
//  Copyright (c) 2015 Nir Ninio. All rights reserved.
//

#import "FlowerViewController.h"

#import "ProcessOne.h"
#import "ProcessTwo.h"

#import "ProcessOneSeed.h"
#import "ProcessTwoSeed.h"

#import "FlowerProcessListener.h"

@interface FlowerViewController ()

@end

@implementation FlowerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ProcessOne* proc1 = [[ProcessOne alloc] initWithSeed:[[ProcessOneSeed alloc] init]];
    FlowerProcessListener* del1 = [[FlowerProcessListener alloc] initWithProcessId:proc1.identifier];
    [[Flower flower] executeProcess:proc1 notify:del1];
    
    ProcessTwo* proc2 = [[ProcessTwo alloc] initWithSeed:[[ProcessTwoSeed alloc] init]];
    FlowerProcessListener* del2 = [[FlowerProcessListener alloc] initWithProcessId:proc2.identifier];
    [[Flower flower] executeProcess:proc2 notify:del2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
