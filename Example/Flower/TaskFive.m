//
//  TaskFive.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskFive.h"
#import "ProcessTwoSeed.h"

@implementation TaskFive

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Five" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task five do work");
    ((ProcessTwoSeed*)self.seed).taskFiveChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end