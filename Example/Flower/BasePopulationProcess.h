//
//  BasePopulationProcess.h
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//


#import <Flower/Flower.h>
#import "ICapitalService.h"

@interface BasePopulationProcess : FlowerProcess

@property (nonatomic, weak) id<ICapitalService> service;

-(instancetype) initWithSeed:(FlowerSeed*)seed andService:(id<ICapitalService>)service;

@end