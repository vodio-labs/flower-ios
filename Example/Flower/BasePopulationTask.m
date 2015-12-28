//
//  BasePopulationTask.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "BasePopulationTask.h"

@interface BasePopulationTask ()

@property (nonatomic, weak) id<ICapitalService> service;

@end


@implementation BasePopulationTask

-(void) setService:(id<ICapitalService>)service {
    _service = service;
}

-(NSString*) serviceUrlForCountry:(NSString*)city {
    if (city && [city length] > 0) {
        return [self.service urlForCity:city];
    }
    return nil;
}

-(CGFloat) population:(NSInteger)population inArea:(NSInteger)area {
    if (self.service) {
        return [self.service population:population inArea:area];
    }
    return 0;
}

@end