//
//  FlowerProcessListener.h
//  Flower
//
//  Created by Nir Ninio on 13/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flower/Flower.h>

@interface FlowerProcessListener : NSObject <FlowerDelegate>

@property (nonatomic, strong, readonly) NSString* processId;
@property (nonatomic, strong) FlowerSeed* seed;
@property (nonatomic) NSInteger tasksCount;
@property (nonatomic, strong) NSError* error;
@property (nonatomic) CGFloat progress;

-(instancetype) initWithProcessId:(NSString*)processId;

@end