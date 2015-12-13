//
//  TestProcessOne.h
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Flower/Flower.h>
#import "TestSeedOne.h"

@interface TestProcessOne : FlowerProcess

-(instancetype)initWithTextOne:(NSString*)text;
-(instancetype)initWithTextSecond:(NSString*)text;

@end
