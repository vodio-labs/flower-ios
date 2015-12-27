//
//  PopulationSeed.h
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/Flower.h>
#import "CitySeed.h"

@interface PopulationSeed : FlowerSeed

-(instancetype) initWithCities:(NSArray*)cityNames;
+(instancetype) seedWithCities:(NSArray*)cityNames;

-(CitySeed*) seedForCity:(NSString*)cityName;

@property (nonatomic, strong) NSArray* cities; // of type CitySeed

@end