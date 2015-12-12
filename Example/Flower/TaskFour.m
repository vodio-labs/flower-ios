//
//  TaskFour.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskFour.h"
#import "ProcessTwoSeed.h"

@implementation TaskFour

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Four" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task four do work");
    ((ProcessTwoSeed*)self.seed).taskFourChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end