//
//  TaskTwo.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskTwo.h"
#import "ProcessOneSeed.h"

@implementation TaskTwo

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Two" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task two do work");
    ((ProcessOneSeed*)self.seed).taskTwoChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end