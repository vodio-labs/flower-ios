//
//  PopulationProcess.h
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "BasePopulationProcess.h"

@interface PopulationProcess : BasePopulationProcess

-(instancetype) initWithCapitalCities:(NSArray*)cities andService:(id<ICapitalService>)service;

@end