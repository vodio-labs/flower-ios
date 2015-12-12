//
//  TaskSeven.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskSeven.h"
#import "ProcessTwoSeed.h"

@implementation TaskSeven

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Seven" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task seven do work");
    ((ProcessTwoSeed*)self.seed).taskSevenChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end