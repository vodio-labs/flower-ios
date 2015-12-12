//
//  FlowerTask.h
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowerSeed.h"

@class FlowerTask;

@protocol FlowerTaskDelegate <NSObject>

-(void) task:(FlowerTask*)task progressChanged:(CGFloat)progress;
-(void) task:(FlowerTask*)task finishedWithError:(NSError*)error;

@end

@interface FlowerTask : NSObject

@property (nonatomic, strong, readonly) NSString* taskId;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic) id<FlowerTaskDelegate> delegate;
@property (nonatomic, strong, readonly) FlowerSeed* seed;
@property (nonatomic) CGFloat progress;

@property (nonatomic, strong, readonly) NSError* error;

@property (nonatomic, strong) FlowerTask* next; // next serial task
@property (nonatomic, strong) FlowerTask* dispatcher; // dispatcher task

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate;

-(instancetype)initWithName:(NSString*)name
                andDelegate:(id<FlowerTaskDelegate>)delegate NS_DESIGNATED_INITIALIZER;

-(NSString*) taskDescription;
-(void) runWithSeed:(FlowerSeed*)seed;
-(void) cancel;

-(void) taskFinishedWithError:(NSError*)error;

@end