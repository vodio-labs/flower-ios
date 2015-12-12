//
//  FlowerTester.m
//  Crave_IOS
//
//  Created by Nir Ninio on 19/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerTester.h"
#import "Flower.h"
#import "ProcessOne.h"
#import "ProcessTwo.h"
#import "ProcessOneSeed.h"
#import "ProcessTwoSeed.h"
#import "FlowerProcessDelegate.h"

@implementation FlowerTester

+(void)test {
    
    ProcessOne* proc1 = [[ProcessOne alloc] initWithSeed:[[ProcessOneSeed alloc] init]];
    FlowerProcessDelegate* del1 = [[FlowerProcessDelegate alloc] initWithProcessId:proc1.identifier];
    [[Flower flower] executeProcess:proc1 notify:del1];
    
    ProcessTwo* proc2 = [[ProcessTwo alloc] initWithSeed:[[ProcessTwoSeed alloc] init]];
    FlowerProcessDelegate* del2 = [[FlowerProcessDelegate alloc] initWithProcessId:proc2.identifier];
    [[Flower flower] executeProcess:proc2 notify:del2];
}

@end