//
//  Flower.h
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowerProcess.h"
#import "FlowerSeed.h"

@protocol FlowerDelegate <NSObject>

-(void) process:(FlowerProcess*)process finishedWithSeed:(FlowerSeed*)seed;
-(void) process:(FlowerProcess*)process failedWithError:(NSError*)error;

@optional

-(void) process:(FlowerProcess*)process startedWithTaskCount:(NSInteger)tasksCount;
-(void) process:(FlowerProcess*)process progressChanged:(CGFloat)progress;

@end

@interface Flower : NSObject <FlowerProcessDelegate>

+(instancetype) flower;

-(NSString*) executeProcess:(FlowerProcess*)process notify:(id<FlowerDelegate>)delegate;
-(BOOL) cancelProcessWithId:(NSString*)processId;
-(FlowerProcessState) processState:(NSString*)processId;

@end