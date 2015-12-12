//
//  TaskNine.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskNine.h"
#import "ProcessTwoSeed.h"

@implementation TaskNine

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Nine" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task nine do work");
    ((ProcessTwoSeed*)self.seed).taskNineChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end