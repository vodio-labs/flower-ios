//
//  TaskEight.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskEight.h"
#import "ProcessTwoSeed.h"

@implementation TaskEight

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Eight" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task eight do work");
    ((ProcessTwoSeed*)self.seed).taskEightChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end