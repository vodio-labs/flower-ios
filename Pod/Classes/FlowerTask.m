// FlowerTask.m
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
-(void) cancel {
    if (self.next) {
        [self.next cancel];
    }
}

// override with actual work - or get an error for not existing ...
-(void) doWork {
    NSLog(@"Task: %@ not implemented doWork", self.name);
    [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData
                                 andMessage:kFlowerErrorTaskNotImplemented]];
}

@end