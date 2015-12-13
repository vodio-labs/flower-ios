//
//  TestTaskOne.m
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "TestTaskOne.h"
#import "TestDataSeed.h"
#import <Flower/FlowerError.h>

@implementation TestTaskOne

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"TestTaskOne" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    
    if (self.seed && [self.seed isKindOfClass:[TestDataSeed class]]) {
        
        TestDataSeed* dataSeed = (TestDataSeed*)self.seed;
        
        dataSeed.dataItemOne = self.name;
        
        [self taskFinishedWithError:nil];
        
    }
    else {
        return [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData]];
    }
}

@end