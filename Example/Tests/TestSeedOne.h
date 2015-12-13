//
//  TestSeedOne.h
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/Flower.h>
#import "TestDataSeed.h"

@interface TestSeedOne : FlowerSeed

@property (strong, nonatomic) TestDataSeed* firstSeed;
@property (strong, nonatomic) TestDataSeed* secondSeed;

+(instancetype) seedWithOne:(NSString*)text;
+(instancetype) seedWithSecond:(NSString*)text;

@end