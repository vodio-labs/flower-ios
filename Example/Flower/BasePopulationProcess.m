//
//  BasePopulationProcess.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "BasePopulationProcess.h"

#import "BasePopulationProcess.h"
#import "BasePopulationTask.h"

@implementation BasePopulationProcess

#pragma mark - overrides to add ICapitalService to task

-(instancetype) initWithSeed:(FlowerSeed*)seed andService:(id<ICapitalService>)service {
    if (self = [super initWithSeed:seed buildable:NO]) { // do not build process yet, only after setting the service delegate
        _service = service;
        [self buildProcess];
    }
    return self;
}

-(FlowerTask*) taskOf:(Class)taskClass {
    FlowerTask* task = [super taskOf:taskClass];
    if ([task isKindOfClass:[BasePopulationTask class]]) {
        [((BasePopulationTask*)task) setService:self.service];
    }
    return task;
}

-(FlowerProcess*) processOf:(Class)processClass withSeed:(FlowerSeed*)seed {
    FlowerProcess* process = [[processClass alloc] initWithSeed:seed buildable:NO];
    if ([process isKindOfClass:[BasePopulationProcess class]]) {
        ((BasePopulationProcess*)process).service = self.service;
        [process buildProcess];
    }
    return process;
}

@end