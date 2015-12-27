//
//  CitySeed.h
//  Flower
//
//  Created by Nir Ninio on 26/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/Flower.h>

@interface CitySeed : FlowerSeed

-(instancetype)initWithName:(NSString*)cityName;
+(instancetype) seedWithName:(NSString*)cityName;

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic) CGFloat populationCalculated;

@end