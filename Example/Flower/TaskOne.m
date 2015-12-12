//
//  TaskOne.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskOne.h"
#import "ProcessOneSeed.h"

@implementation TaskOne

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task One" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task one do work");
    ((ProcessOneSeed*)self.seed).taskOneChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end