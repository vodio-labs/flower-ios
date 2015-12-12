//
//  FlowerProcessDelegate.m
//  Crave_IOS
//
//  Created by Nir Ninio on 19/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerProcessDelegate.h"

@implementation FlowerProcessDelegate

-(instancetype) initWithProcessId:(NSString*)processId {
    if (self = [super init]) {
        _processId = processId;
    }
    return self;
}

-(void) process:(FlowerProcess*)process finishedWithSeed:(FlowerSeed*)seed {
    NSLog(@"process %@ finished with seed: %@", self.processId, [seed description]);
}

-(void) process:(FlowerProcess*)process failedWithError:(NSError*)error {
    NSLog(@"process %@ finished with error: %@", self.processId, error);
}

-(void) process:(FlowerProcess*)process startedWithTaskCount:(NSInteger)tasksCount {
    NSLog(@"process %@ started with tasks count = %ld", self.processId, (long)tasksCount);
}

-(void) process:(FlowerProcess*)process progressChanged:(CGFloat)progress {
    NSLog(@"process %@ progress changed : %f", self.processId, progress);
}

@end