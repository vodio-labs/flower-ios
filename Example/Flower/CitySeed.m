//
//  CitySeed.m
//  Flower
//
//  Created by Nir Ninio on 26/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "CitySeed.h"

@implementation CitySeed

-(instancetype)init {
    return [self initWithName:nil];
}

-(instancetype)initWithName:(NSString*)cityName {
    if (self = [super init]) {
        _name = cityName;
    }
    return self;
}

+(instancetype) seedWithName:(NSString*)cityName {
    if (cityName) {
        return [[self alloc] initWithName:cityName];
    }
    return nil;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ : %f", self.name, self.populationCalculated];
}

@end