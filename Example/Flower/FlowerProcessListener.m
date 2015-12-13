//
//  FlowerProcessListener.m
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "FlowerProcessListener.h"

@implementation FlowerProcessListener

-(instancetype) initWithProcessId:(NSString*)processId {
    if (self = [super init]) {
        _processId = processId;
        _progress = 0.0;
    }
    return self;
}

-(void) process:(FlowerProcess*)process finishedWithSeed:(FlowerSeed*)seed {
    if ([process.identifier isEqualToString:self.processId]) {
        self.seed = seed;
        NSLog(@"process %@ finished with seed: %@", self.processId, [seed description]);
    }
}

-(void) process:(FlowerProcess*)process failedWithError:(NSError*)error {
    if ([process.identifier isEqualToString:self.processId]) {
        self.error = error;
        NSLog(@"process %@ finished with error: %@", self.processId, error);
    }
}

-(void) process:(FlowerProcess*)process startedWithTaskCount:(NSInteger)tasksCount {
    if ([process.identifier isEqualToString:self.processId]) {
        self.tasksCount = tasksCount;
        NSLog(@"process %@ started with tasks count = %ld", self.processId, (long)tasksCount);
    }
}

-(void) process:(FlowerProcess*)process progressChanged:(CGFloat)progress {
    if ([process.identifier isEqualToString:self.processId]) {
        self.progress = progress;
        NSLog(@"process %@ progress changed : %f", self.processId, progress);
    }
}

@end
