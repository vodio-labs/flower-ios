//
//  OrderPopulationByAreaSize.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/FlowerError.h>
#import "OrderPopulationByAreaSize.h"
#import "PopulationSeed.h"

@implementation OrderPopulationByAreaSize

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"Order By Population" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    if (self.seed && [self.seed isKindOfClass:[PopulationSeed class]]) {
        PopulationSeed* pseed = (PopulationSeed*)self.seed;
        
        NSArray* sortedArray = [pseed.cities sortedArrayUsingDescriptors:
                                @[[NSSortDescriptor sortDescriptorWithKey:@"populationCalculated" ascending:YES]]];
        
        pseed.cities = sortedArray; // set the sorted array back
        [self taskFinishedWithError:nil];
    }
    else {
        [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData andMessage:@"population seed is not valid"]];
    }
}

@end