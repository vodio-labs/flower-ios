//
//  FlowerSeed.m
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerSeed.h"

@implementation FlowerSeed

-(instancetype) init {
    if (self = [super init]) {
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

-(Class) seedClassType {
    return [self class];
}

-(NSString *) description {
    return [NSString stringWithFormat:@" { type = %@, identifier = %@ } ", [self class], self.identifier];
}

@end