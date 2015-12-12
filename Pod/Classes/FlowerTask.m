//
//  FlowerTask.m
//  Crave_IOS
//
//  Created by Nir Ninio on 06/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerTask.h"
#import "FlowerError.h"

@interface FlowerTask ()

@property (nonatomic) CGFloat lastProgressNotified;

@end

@implementation FlowerTask

-(instancetype)init {
    return [self initWithDelegate:nil];
}

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    return [self initWithName:@"invalid" andDelegate:delegate];
}

-(instancetype)initWithName:(NSString*)name andDelegate:(id<FlowerTaskDelegate>)delegate {
    if (self = [super init]) {
        _taskId = [[NSUUID UUID] UUIDString];
        _name = name;
        _delegate = delegate;
        _progress = 0.0; // not going through the setter because don't need to notify anyone
        _lastProgressNotified = 0.0;
    }
    return self;
}

-(void) setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(task:progressChanged:)]) {
        [self.delegate task:self progressChanged:MAX(0,(self.progress-self.lastProgressNotified))];
        _lastProgressNotified = progress;
    }
}

-(void) setSeed:(FlowerSeed*) seed {
    _seed = seed;
}

-(void) setDelegate:(id<FlowerTaskDelegate>)delegate {
    _delegate = delegate;
    if (self.next) {
        self.next.delegate = delegate;
    }
}

-(NSString*) taskDescription {
    return [NSString stringWithFormat:@"%@[%@]", self.name, self.taskId];
}

-(void) runWithSeed:(FlowerSeed*) seed {
    
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
        NSLog(@" app is in the background. executing: %@", self);
        NSLog(@"background time remaining = %.1f seconds", [UIApplication sharedApplication].backgroundTimeRemaining);
    }
    
    self.seed = seed;
    self.lastProgressNotified = self.progress; // starts with current status (probably 0.0)
    [self doWork];
}

-(void) taskFinishedWithError:(NSError*)error {
    
    _error = error; // reference to the error to later process if such occur
    self.progress = 1.0; // this will send the progress changed with last delta pf process value
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(task:finishedWithError:)]) {
        [self.delegate task:self finishedWithError:error];
    }
}

// can override to do something when cancelled
-(void) cancel { }


// override with actual work - or get an error for not existing ...
-(void) doWork {
    NSLog(@"Task: %@ not implemented doWork", self.name);
    [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData
                                 andMessage:kFlowerErrorTaskNotImplemented]];
}

@end