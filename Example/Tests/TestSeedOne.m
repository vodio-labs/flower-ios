//
//  TestSeedOne.m
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "TestSeedOne.h"

@implementation TestSeedOne

-(instancetype) init {
    if (self = [super init]) {
        _firstSeed = [[TestDataSeed alloc] init];
        _secondSeed = [[TestDataSeed alloc] init];
    }
    return self;
}

+(instancetype) seedWithOne:(NSString*)text {
    if (text) {
        TestSeedOne* seed = [[TestSeedOne alloc] init];
        seed.firstSeed.dataItemOne = text;
        return seed;
    }
    return nil;
}

+(instancetype) seedWithSecond:(NSString*)text {
    if (text) {
        TestSeedOne* seed = [[TestSeedOne alloc] init];
        seed.secondSeed.dataItemOne = text;
        return seed;
    }
    return nil;
}

@end