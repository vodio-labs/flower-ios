//
//  TaskThree.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "TaskThree.h"
#import "ProcessOneSeed.h"

@implementation TaskThree

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Task Three" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    NSLog(@"task three do work");
    ((ProcessOneSeed*)self.seed).taskThreeChecked = @"checked";
    [self taskFinishedWithError:nil];
}

@end