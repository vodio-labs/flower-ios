// Flower.m
// Copyright © 2015 Vodio Labs Ltd. (http://www.vod.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "Flower.h"

@interface Flower ()

@property (nonatomic, strong) NSMutableDictionary* processes; // currently managed processes
@property (nonatomic, strong) NSMutableDictionary* processDelegates; // processes delegates

@end

@implementation Flower

-(instancetype) init {
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
        flower = [[[self class] alloc] init];
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
        
        // in case this process needs to be able to complete in the background
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