//
//  FlowerSeed.h
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowerSeed : NSObject

@property (nonatomic, strong, readonly) NSString* identifier;

-(Class) seedClassType;

@end