//
//  TestProcessOne.m
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "TestProcessOne.h"
#import "TestTaskOne.h"
#import "TestTaskTwo.h"
#import "TestSeedOne.h"

@implementation TestProcessOne

-(instancetype)initWithTextOne:(NSString*)text {
    if (self = [super initWithSeed:[TestSeedOne seedWithOne:text]]) {
        
    }
    return self;
}

-(instancetype)initWithTextSecond:(NSString*)text {
    if (self = [super initWithSeed:[TestSeedOne seedWithSecond:text]]) {
        
    }
    return self;
}

-(void) buildProcess {
    
    if (self.seed && [self.seed isKindOfClass:[TestSeedOne class]]) {
        
        TestSeedOne* testSeed = (TestSeedOne*)self.seed;
        
        [self addTaskOf:[TestTaskOne class] withSeed:testSeed.firstSeed progressVolume:0.2];
        [self addTaskOf:[TestTaskTwo class] withSeed:testSeed.secondSeed progressVolume:0.8];
    }
}

@end