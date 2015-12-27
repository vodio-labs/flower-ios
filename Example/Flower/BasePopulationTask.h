//
//  BasePopulationTask.h
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//


#import <Flower/Flower.h>
#import "ICapitalService.h"

@interface BasePopulationTask : FlowerTask

-(void) setService:(id<ICapitalService>)service;

-(NSString*) serviceUrlForCountry:(NSString*)city;
-(CGFloat) population:(NSInteger)population inArea:(NSInteger)area;

@end