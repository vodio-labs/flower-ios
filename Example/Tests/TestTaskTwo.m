//
//  TestTaskTwo.m
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "TestTaskTwo.h"
#import "TestDataSeed.h"
#import <Flower/FlowerError.h>


@implementation TestTaskTwo

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"TestTaskTwo" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    
    if (self.seed && [self.seed isKindOfClass:[TestDataSeed class]]) {
        
        TestDataSeed* dataSeed = (TestDataSeed*)self.seed;
        
        dataSeed.dataItemTwo = self.name;
        
        [self taskFinishedWithError:nil];
        
    }
    else {
        return [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData]];
    }
}

@end