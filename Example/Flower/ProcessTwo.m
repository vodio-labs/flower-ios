//
//  ProcessTwo.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "ProcessTwo.h"
#import "ProcessOne.h"
#import "ProcessTwoSeed.h"
#import "TaskFour.h"
#import "TaskFive.h"
#import "TaskSix.h"
#import "TaskSeven.h"
#import "TaskEight.h"
#import "TaskNine.h"
#import "TaskTen.h"

@implementation ProcessTwo

-(instancetype) init {
    if (self = [super initWithSeed:[[ProcessTwoSeed alloc] init]]) {
        
    }
    return self;
}

-(void) buildProcess {
    ProcessTwoSeed* seed = (ProcessTwoSeed*)self.seed;

    [self addTaskOf:[TaskFour class] withSeed:seed progressVolume:0.1];
    [self addProcessOf:[ProcessOne class] withSeed:seed.oneSeed progressVolume:0.2];
    [self addTaskOf:[TaskFive class] withSeed:seed progressVolume:0.1];
    
    // make sure no Nil is inserted to the array, otherwise it will crash
    [self addParallelWithTasks:
     @[[self parallelTaskOf:[TaskSix class] withSeed:seed progressVolume:0.1],
       [self parallelProcessOf:[ProcessOne class] withSeed:seed.parallerOneSeed progressVolume:0.2],
       [self parallelTaskOf:[TaskSeven class] withSeed:seed progressVolume:0.1],
       [self parallelTaskOf:[TaskEight class] withSeed:seed progressVolume:0.1]]];
    
    [self addTaskOf:[TaskNine class] withSeed:seed progressVolume:0.05];
    [self addTaskOf:[TaskTen class] withSeed:seed progressVolume:0.05];
}

@end