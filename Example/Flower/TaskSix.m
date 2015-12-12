//
//  TaskSix.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskSix.h"
#import "ProcessTwoSeed.h"

@implementation TaskSix

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Six" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task six do work");
    ((ProcessTwoSeed*)self.seed).taskSixChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end