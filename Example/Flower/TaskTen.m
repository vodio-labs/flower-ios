//
//  TaskTen.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskTen.h"
#import "ProcessTwoSeed.h"

@implementation TaskTen

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Ten" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task ten do work");
    ((ProcessTwoSeed*)self.seed).taskTenChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end