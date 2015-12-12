//
//  Flower.m
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "Flower.h"

@interface Flower ()

@property (nonatomic, strong) NSMutableDictionary* processes;
@property (nonatomic, strong) NSMutableDictionary* processDelegates;

@end

@implementation Flower

-(instancetype) initFlower {
    if (self = [super init]) {
        _processes = [NSMutableDictionary dictionary];
        _processDelegates = [NSMutableDictionary dictionary];
    }
    return self;
}

+(instancetype) flower {
    static Flower* flower;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flower = [[[self class] alloc] initFlower];
    });
    return flower;
}

-(FlowerProcess*) getProcess:(NSString*)processId {
    if (processId && [processId isKindOfClass:[NSString class]] && processId.length > 0) {
        return self.processes[processId];
    }
    return nil;
}

-(id<FlowerDelegate>) getProcessDelegate:(NSString*)processId {
    if (processId && [processId isKindOfClass:[NSString class]] && processId.length > 0) {
        return self.processDelegates[processId];
    }
    return nil;
}

-(NSString*) executeProcess:(FlowerProcess*)process notify:(id<FlowerDelegate>)delegate {
    if (delegate && process && process.state == PROCESS_CREATED) {
        
        if (process.completesInBackground && process.backgroundIdentifier == UIBackgroundTaskInvalid) {
            
            // tell iOS that we need extra time in case the app moves to the background
            process.backgroundIdentifier =
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                NSLog(@"background expiration handler called");
                
                [[UIApplication sharedApplication] endBackgroundTask:process.backgroundIdentifier];
                process.backgroundIdentifier = UIBackgroundTaskInvalid;
            }];
        }
        
        self.processes[process.identifier] = process;
        self.processDelegates[process.identifier] = delegate;
        
        [process structure]; // prints the structure of the process
        [process dispatchAndNotifyDelegate:self];
    }
    return nil;
}

-(BOOL) cancelProcessWithId:(NSString*)processId {
    FlowerProcess* process = [self getProcess:processId];
    if (process) {
        [self.processes removeObjectForKey:processId];
        [self.processDelegates removeObjectForKey:processId];
        [process cancel];
        return YES;
    }
    return NO;
}

-(FlowerProcessState) processState:(NSString *)processId {
    FlowerProcess* process = [self getProcess:processId];
    if (process) {
        return process.state;
    }
    return PROCESS_NOT_EXIST;
}

#pragma mark - FlowerProcessDelegate

-(void) processStarted:(NSString*)processId {
    id<FlowerDelegate> delegate = [self getProcessDelegate:processId];
    FlowerProcess* process = [self getProcess:processId];
    
    if (process && delegate && [delegate respondsToSelector:@selector(process:startedWithTaskCount:)]) {
        [delegate process:process startedWithTaskCount:process.tasksCount];
    }
}

-(void) process:(NSString*)processId progressChanged:(CGFloat)progress {
    FlowerProcess* process = [self getProcess:processId];
    id<FlowerDelegate> delegate = [self getProcessDelegate:processId];
    if (process && delegate && [delegate respondsToSelector:@selector(process:progressChanged:)]) {
        [delegate process:process progressChanged:progress];
    }
}

-(void) process:(NSString*)processId didFinishWithSeed:(id)seed error:(NSError*)error{
    FlowerProcess* process = [self getProcess:processId];
    id<FlowerDelegate> delegate = [self getProcessDelegate:processId];
    if (process && delegate) {
        if (error == nil) {
            if ([delegate respondsToSelector:@selector(process:finishedWithSeed:)]) {
                [delegate process:process finishedWithSeed:process.seed];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(process:failedWithError:)]) {
                [delegate process:process failedWithError:error];
            }
        }
    }    
    [self removeProcess:process];
}

-(void) process:(NSString*)processId didCancelWithError:(NSError*)error {
    [self removeProcess:[self getProcess:processId]];
}

-(void) removeProcess:(FlowerProcess*)process {
    if (process) {
        [self.processes removeObjectForKey:process.identifier];
        [self.processDelegates removeObjectForKey:process.identifier];
        
        if (process && process.completesInBackground && process.backgroundIdentifier != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:process.backgroundIdentifier];
            process.backgroundIdentifier = UIBackgroundTaskInvalid;
        }
    }
}

@end