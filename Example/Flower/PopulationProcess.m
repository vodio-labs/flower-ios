//
//  PopulationProcess.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/Flower.h>
#import "PopulationProcess.h"
#import "PopulationSeed.h"
#import "CitySeed.h"
#import "CityPopulationTask.h"
#import "OrderPopulationByAreaSize.h"

@implementation PopulationProcess

-(instancetype) init {
    return [self initWithCapitalCities:nil andService:nil];
}

-(instancetype) initWithCapitalCities:(NSArray*)cities andService:(id<ICapitalService>)service {
    if (self = [super initWithSeed:[PopulationSeed seedWithCities:cities] andService:service]) {
        
    }
    return self;
}

-(void) buildProcess {
    
    if (self.seed && [self.seed isKindOfClass:[PopulationSeed class]]) {
        PopulationSeed* pseed = (PopulationSeed*)self.seed;
        NSMutableArray* tasks = [NSMutableArray array];
        
        NSArray* citySeeds = pseed.cities;
        
        if (citySeeds && [citySeeds count] > 0) {
            CGFloat progressVolume = 0.9 / [citySeeds count];
            for (CitySeed* cseed in citySeeds) {
                FlowerTask* task = [self parallelTaskOf:[CityPopulationTask class]
                                               withSeed:[pseed seedForCity:cseed.name]
                                         progressVolume:progressVolume];
                if (task) {
                    [tasks addObject:task];
                }
            }
        }
        if ([tasks count] > 0 && [tasks count] == [pseed.cities count]) {
            [self addParallelWithTasks:tasks];
            [self addTaskOf:[OrderPopulationByAreaSize class] withSeed:self.seed progressVolume:0.1];
        }
    }
    else {
        NSLog(@"invalid data - cannot build process");
    }
}

@end