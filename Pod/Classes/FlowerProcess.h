//
//  FlowerProcess.h
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowerTask.h"
#import "FlowerSeed.h"

typedef NS_ENUM(NSInteger, FlowerProcessState) {
    PROCESS_NOT_EXIST,
    PROCESS_CREATED,
    PROCESS_RUNNING,
    PROCESS_WAITING,
    PROCESS_FINISHED,
    PROCESS_CANCELLED
};

@protocol FlowerProcessDelegate <NSObject>

-(void) processStarted:(NSString*)processId;
-(void) process:(NSString*)processId progressChanged:(CGFloat)progress;
-(void) process:(NSString*)processId didFinishWithSeed:(id)seed error:(NSError*)error;
-(void) process:(NSString*)processId didCancelWithError:(NSError*)error;

@end

@interface FlowerProcess : NSObject <FlowerTaskDelegate>

-(instancetype) initWithSeed:(FlowerSeed*)seed;
-(instancetype) initWithSeed:(FlowerSeed*)seed buildable:(BOOL)buildable NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) FlowerProcessState state;
@property (nonatomic, readonly) NSInteger tasksCount;
@property (nonatomic, strong) FlowerSeed* seed;

@property (nonatomic, strong, readonly) FlowerTask* root;
@property (nonatomic, strong, readonly) FlowerTask* end;

@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic) BOOL blocking; // whether this process is blocking interaction
@property (nonatomic) BOOL completesInBackground; // whether this process completes in the background
@property (nonatomic) UIBackgroundTaskIdentifier backgroundIdentifier;

@property (nonatomic, strong, readonly) NSMutableDictionary* tasksMetadata;

-(void) structure;
-(void) buildProcess;
-(void) dispatchAndNotifyDelegate:(id<FlowerProcessDelegate>)delegate;
-(void) cancel;

// build the process
-(FlowerTask*) taskOf:(Class)taskClass;
-(FlowerProcess*) processOf:(Class)processClass withSeed:(FlowerSeed*)seed;

-(FlowerTask*) addTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;
-(FlowerTask*) addProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;
-(FlowerTask*) addParallelWithTasks:(NSArray*)tasks;

-(FlowerTask*) parallelTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;
-(FlowerTask*) parallelProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;

@end