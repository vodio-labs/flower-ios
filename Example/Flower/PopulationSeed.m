//
//  PopulationSeed.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "PopulationSeed.h"


@interface PopulationSeed ()

@property (nonatomic, strong, readonly) NSMutableDictionary* citiesDict; // of type CitySeed

@end

@implementation PopulationSeed

-(instancetype)init {
    return [self initWithCities:nil];
}

-(instancetype)initWithCities:(NSArray*)cityNames {
    if (self = [super init]) {
        _citiesDict = [NSMutableDictionary dictionary];
        if (cityNames && [cityNames isKindOfClass:[NSArray class]]) {
            for (NSString* cityName in cityNames) {
                if (self.citiesDict[cityName] == nil) {
                    CitySeed* cseed = [CitySeed seedWithName:cityName];
                    if (cseed) {
                        self.citiesDict[cityName] = cseed;
                    }
                }
            }
        }
        _cities = [self.citiesDict allValues];
    }
    return self;
}

+(instancetype) seedWithCities:(NSArray*)cityNames {
    if (cityNames && [cityNames isKindOfClass:[NSArray class]]) {
        return [[self alloc] initWithCities:cityNames];
    }
    return nil;
}

-(CitySeed*) seedForCity:(NSString*)cityName {
    return cityName ? self.citiesDict[cityName] : nil;
}

@end