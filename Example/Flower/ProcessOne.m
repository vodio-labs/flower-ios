//
//  ProcessOne.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "ProcessOne.h"
#import "ProcessOneSeed.h"
#import "TaskOne.h"
#import "TaskTwo.h"
#import "TaskThree.h"

@implementation ProcessOne

-(instancetype) init {
    if (self = [super initWithSeed:[[ProcessOneSeed alloc] init]]) {
        
    }
    return self;
}

-(void) buildProcess {
    [self addTaskOf:[TaskOne class] withSeed:self.seed progressVolume:0.2];
    [self addTaskOf:[TaskTwo class] withSeed:self.seed progressVolume:0.6];
    [self addTaskOf:[TaskThree class] withSeed:self.seed progressVolume:0.2];
}

@end