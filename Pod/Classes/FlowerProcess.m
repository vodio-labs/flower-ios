// FlowerProcess.m
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


#import "FlowerProcess.h"
#import "FlowerError.h"
#import "LoadingView.h"


// ========================================================= //
// ======== DISPATCHER PRIVATE IMPLEMENTATION ============== //

@interface FlowerDispatcherTask : FlowerTask

@property (nonatomic, strong, readonly) dispatch_group_t dispatchGroup;
@property (nonatomic, strong) NSMutableArray* siblings; // parallel tasks we run from this dispatcher

@end


@implementation FlowerDispatcherTask

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"dispatcher" andDelegate:delegate]) {
        _dispatchGroup = dispatch_group_create();
        _siblings = [NSMutableArray array];
    }
    return self;
}

-(void) doWork {

    // wait for all async tasks (siblings) to complete before returning
    dispatch_group_notify(self.dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSError* error = nil;
        for (FlowerTask* task in self.siblings) {
            if (task.error) {
                error = task.error;
                break;
            }
        }
        [self taskFinishedWithError:error];        
    });
}

-(void) cancel {
    for (FlowerTask* task in self.siblings) {
        [task cancel];
    }
    [super cancel];
}

-(void)setDelegate:(id<FlowerTaskDelegate>)delegate {
    for (FlowerTask* sibling in self.siblings) {
        sibling.delegate = delegate;
    }
    [super setDelegate:delegate];
}

-(NSInteger) addSiblings:(NSArray*)siblings {
    NSInteger count = 0;
    if (siblings && [siblings isKindOfClass:[NSArray class]] && [siblings count] > 0) {
        for (FlowerTask* task in siblings) {
            if (task && [task isKindOfClass:[FlowerTask class]]) {
                FlowerTask* current = task;
                while (current) {
                    current.dispatcher = self;
                    current = current.next;
                }
                [self.siblings addObject:task];
                count ++;
            }
        }
    }
    return count;
}

@end

// ========================================================= //
// ========================================================= //



// ========================================================= //
// ========= TASK METADATA PRIVATE IMPLEMENTATION ========== //

@interface FlowerTaskMetadata : NSObject

-(instancetype) initWithSeed:(FlowerSeed*)seed
           andProgressVolume:(CGFloat)volume NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) FlowerSeed* taskSeed;
@property (nonatomic) CGFloat progressVolume;

@end


@implementation FlowerTaskMetadata

-(instancetype)init {
    return [self initWithSeed:nil andProgressVolume:0.0];
}

-(instancetype) initWithSeed:(FlowerSeed*)seed andProgressVolume:(CGFloat)volume {
    if (self = [super init]) {
        _taskSeed = seed;
        _progressVolume = volume;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"{ seed : %@, volume = %f }", [self.taskSeed description], self.progressVolume];
}

@end


// ========================================================= //
// ========================================================= //


@interface FlowerProcess ()

@property (nonatomic, weak) id<FlowerProcessDelegate> delegate;
@property (nonatomic, strong) dispatch_queue_t concurrentProgressQueue;

@end


@implementation FlowerProcess

@synthesize progress = _progress;

-(instancetype) init {
    return [self initWithSeed:nil];
}

-(instancetype) initWithSeed:(FlowerSeed*)seed {
    return [self initWithSeed:seed buildable:YES];
}

-(instancetype) initWithSeed:(FlowerSeed*)seed buildable:(BOOL)buildable {
    if (self = [super init]) {
        _identifier = [[NSUUID UUID] UUIDString];
        _tasksMetadata = [NSMutableDictionary dictionary];
        _state = PROCESS_CREATED;
        _seed = seed;
        _concurrentProgressQueue = dispatch_queue_create("flower.process.progress.queue", DISPATCH_QUEUE_CONCURRENT);
        
        if (buildable) {
            [self buildProcess];
        }
    }
    return self;
}

// override to implement specific build
-(void) buildProcess {}

-(void) setState:(FlowerProcessState)state {
    _state = state;
}

-(CGFloat) progress {
    __block NSNumber* progress;
    dispatch_sync(self.concurrentProgressQueue, ^{
        progress = [NSNumber numberWithFloat:_progress];
    });
    return [progress floatValue];
}

- (void) setProgress:(CGFloat)progress {
    dispatch_barrier_async(self.concurrentProgressQueue, ^{
        _progress = progress;
    });
}

-(void) addToProgress:(CGFloat)progress {
    dispatch_barrier_async(self.concurrentProgressQueue, ^{
        _progress += progress;
    });
}

-(void) setRoot:(FlowerTask *)root {
    _root = root;
}

-(void) setEnd:(FlowerTask *)end {
    _end = end;
}

- (NSInteger) tasksCount {
    NSInteger count = 0;
    if (self.tasksMetadata) {
        for (NSString* key in self.tasksMetadata) {
            FlowerTaskMetadata* metadata = self.tasksMetadata[key];
            if (metadata && metadata.progressVolume > 0.0) {
                count ++;
            }
        }
    }
    return count;
}

-(void) structure {
    NSLog(@"process: [%@] state: %ld", [self class], (long)self.state);
    if (self.root) {
        NSLog(@"%@", [self structureNode:self.root inStructure:[NSMutableString string]]);
    }
    else {
       NSLog(@"process: [%@] no tasks", [self class]);
    }
    NSLog(@"metadata: %@", self.tasksMetadata);
}

-(NSMutableString*) structureNode:(FlowerTask*)node inStructure:(NSMutableString*)structure {
    while (node) {
        [structure appendFormat:@"[%@]", [node taskDescription]];
        if ([node isKindOfClass:[FlowerDispatcherTask class]]) {
            FlowerDispatcherTask* dis = (FlowerDispatcherTask*)node;
            if (dis.siblings) {
                [structure appendString:@" {"];
                for (FlowerTask* s in dis.siblings) {
                    [structure appendString:@" || "];
                    [self structureNode:s inStructure:structure];
                }
                [structure appendString:@" || }"];
            }
        }
        node = node.next;
        if (node) {
            [structure appendString:@"*"];
        }
    }
    return structure;
}

-(void) dispatchAndNotifyDelegate:(id<FlowerProcessDelegate>)delegate {
    
    if (self.state == PROCESS_CREATED) {
        self.delegate = delegate;
        self.progress = 0.0;
        self.state = PROCESS_RUNNING;
        
        FlowerError* error = nil;

        if (!self.root) {
            error = [FlowerError errorWithCode:FlowerErrorInvalidData andMessage:kFlowerErrorRootNodeNotFound];
        }
        else if (!self.seed) {
            error = [FlowerError errorWithCode:FlowerErrorInvalidData andMessage:kFlowerErrorSeedNotFound];
        }
        else if (!self.delegate) {
            error = [FlowerError errorWithCode:FlowerErrorInvalidData andMessage:kFlowerErrorDelegateNotFound];
        }
        
        if (error == nil) {
            
            if ([self.delegate respondsToSelector:@selector(processStarted:)]) {
                [self.delegate processStarted:self.identifier];
            }
            
            if (self.blocking) {
                [[LoadingView instance] startLoading:YES];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self executeNextTask:self.root];
            });
        }
        else {
            [self completedWithError:error];
        }
    }
    else {
        [self completedWithError:[FlowerError errorWithCode:FlowerErrorProcessStateNotValid
                                                 andMessage:kFlowerErrorProcessNotCreated]];
    }
}

-(void) cancel {
    if (self.state != PROCESS_CANCELLED) {
        self.state = PROCESS_CANCELLED;
        [self notifyProcessCancelledWithError:nil];
    }
}

-(void) executeNextTask:(FlowerTask*)task {
    
    if (self.state == PROCESS_RUNNING) {
        
        if (task) {
            
            // this is a background dispatcher - dispatch all siblings
            if ([task isKindOfClass:[FlowerDispatcherTask class]]) {
                
                FlowerDispatcherTask* dispatcher = (FlowerDispatcherTask*)task;
                NSArray* siblings = dispatcher.siblings;
                
                if ([siblings count] > 0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                    for (FlowerTask* t in siblings) {
                        dispatch_group_enter(dispatcher.dispatchGroup);
                        dispatch_async(queue, ^{ [self executeNextTask:t]; });
                    }
                }
            }
            
            // run current task
            FlowerTaskMetadata* metadata = [self.tasksMetadata objectForKey:task.taskId];
            [task runWithSeed:metadata.taskSeed];
        }
        else {
            [self completedWithError:[FlowerError errorWithCode:FlowerErrorProcessStateNotValid
                                                     andMessage:kFlowerErrorTaskNotFound]];
        }
    }
    
    else if (self.state == PROCESS_CANCELLED) {
        // clean up - no moving forward from here
        if (task) {
            
            [task cancel];
            
            if (task.dispatcher) {
                // need to signal on group leaving, so that the dispatcher will finish executing as well
                FlowerDispatcherTask* dispatcher = (FlowerDispatcherTask*)task.dispatcher;
                dispatch_group_leave(dispatcher.dispatchGroup);
            }            
        }
    }
    else {
        [self completedWithError:[FlowerError errorWithCode:FlowerErrorProcessStateNotValid
                                                 andMessage:kFlowerErrorProcessNotRunningOrCancelled]];

    }
}

#pragma mark - report back to Flower engine

-(void) notifyProgressChanged:(CGFloat)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(process:progressChanged:)]) {
            [self.delegate process:self.identifier progressChanged:progress];
        }
    });
}

-(void) notifyProcessCancelledWithError:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(process:didCancelWithError:)]) {
            [self.delegate process:self.identifier didCancelWithError:error];
        }
    });
}

-(void) completedWithError:(NSError*)error {
    self.progress = 1.0;
    self.state = PROCESS_FINISHED;
    
    if (error) {
        NSLog(@"process completed with error: %@", [error localizedDescription]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.blocking) {
            [[LoadingView instance] stopLoading:YES completion:nil];
        }
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(process:didFinishWithSeed:error:)]) {
            [self.delegate process:self.identifier didFinishWithSeed:self.seed error:error];
        }
    });
}

#pragma mark - build tasks list

// overriden by CraveBaseProcess to return crave context process
-(FlowerTask*) taskOf:(Class)taskClass {
    return [[taskClass alloc] initWithDelegate:self];
}

// overriden by CraveBaseProcess to return crave context process
-(FlowerProcess*) processOf:(Class)processClass withSeed:(FlowerSeed*)seed {
    // cannot return process of the same as the one building it - endless loop.
    if (processClass && processClass != [self class]) {
        return [[processClass alloc] initWithSeed:seed];
    }
    return nil;
}

-(FlowerTask*) addTask:(FlowerTask*)task andMetadata:(FlowerTaskMetadata*)metadata {
    if (task && metadata) {
        
        if (!self.tasksMetadata[task.taskId]) {
            self.tasksMetadata[task.taskId] = metadata;
        }
        
        if (self.end) {
            self.end.next = task;
            self.end = task;
        }
        else {
            // setting the root
            self.root = task;
            self.end = self.root;
        }
    }
    return task;
}

// services

// adds a new serial task to the main process route
-(FlowerTask*) addTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume {
    return [self addTask:[self taskOf:taskClass]
            andMetadata:[[FlowerTaskMetadata alloc] initWithSeed:seed andProgressVolume:volume]];
}

// adds a set of new serial tasks (the process set) to the main process route
-(FlowerTask*) addProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume {
    FlowerTask* lastTask = nil;
    FlowerProcess* process = [self processOf:processClass withSeed:seed];
    if (process && process.root) {
        
        process.root.delegate = self; // this will pass through all tree recursively
        
        FlowerTask* current = process.root;
        
        NSMutableDictionary* metadatas = [NSMutableDictionary dictionaryWithDictionary:process.tasksMetadata];
        
        // update all metadata objects
        for (NSString* key in metadatas) {
            FlowerTaskMetadata* md = (FlowerTaskMetadata*)metadatas[key];
            if (md) {
                md.progressVolume *= volume;
            }
        }
        
        // loop on all tasks update volume and add to main process route
        while (current) {
            FlowerTaskMetadata* metadata = [metadatas objectForKey:current.taskId];
            [self addTask:current andMetadata:metadata];
            [metadatas removeObjectForKey:current.taskId];
            lastTask = current;
            current = current.next;
        }
        
        // add all the rest of metadatas
        [self.tasksMetadata addEntriesFromDictionary:metadatas];
    }
    return lastTask;
}

// adds a new SERIAL task of type background ex to the main route process, this task holds refs to parallel other tasks
-(FlowerTask*) addParallelWithTasks:(NSArray*)tasks {
    
    if (tasks && [tasks isKindOfClass:[NSArray class]] && [tasks count] > 0) {
        FlowerDispatcherTask* dispatcher = (FlowerDispatcherTask*)[self taskOf:[FlowerDispatcherTask class]];
        NSInteger validSiblings = [dispatcher addSiblings:tasks];
        
        if (validSiblings == [tasks count]) {
            //progress is not changed for dispatcher task (0.0)
            return [self addTask:dispatcher
                     andMetadata:[[FlowerTaskMetadata alloc] initWithSeed:self.seed andProgressVolume:0.0]];
        }
        else {
            NSLog(@"valid siblings do not match number of input tasks, cannot add parallel tasks");
        }
    }
    return nil;
}

// creates a task, adds the task metadata but NOT adding the task to the main process route
- (FlowerTask*) parallelTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume {
    FlowerTask* task = [self taskOf:taskClass];
    FlowerTaskMetadata* metadata = [[FlowerTaskMetadata alloc] initWithSeed:seed andProgressVolume:volume];
    self.tasksMetadata[task.taskId] = metadata;
    return task;
}

// creates a set of tasks, adds the tasks metadata but NOT adding them to the main process route
-(FlowerTask*) parallelProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume {

    FlowerProcess* process = [self processOf:processClass withSeed:seed];

    if (process && process.root) {
        
        process.root.delegate = self; // this will pass through all tree
        
        FlowerTask* current = process.root;
        
        // loop on all tasks update volume and add to main process route
        while (current) {
            FlowerTaskMetadata* metadata = [process.tasksMetadata objectForKey:current.taskId];
            if (!metadata) {
                NSLog(@"metadata for: %@ is nil", current.taskId);
            }
            metadata.progressVolume *= volume;
            current = current.next;
        }
        [self.tasksMetadata addEntriesFromDictionary:process.tasksMetadata];
    }
    return process.root; // here we return a pointer to the root node
}

#pragma mark - FlowerTaskDelegate

-(void) task:(FlowerTask*)task finishedWithError:(NSError*)error {
    
    if (error) {
        NSLog(@"task: %@ finished with error: %@", task, error);
    }
    else {
        NSLog(@"task: %@ finished", task);
    }
    
    // if this task is assigned with a dispatcher
    if (task && task.dispatcher) {
        // if this is the last task - notify the dispatcher
        if (task.next == nil) {
            FlowerDispatcherTask* dispatcher = (FlowerDispatcherTask*)task.dispatcher;
            dispatch_group_leave(dispatcher.dispatchGroup);
        }
        else {
            if (error == nil) {
                NSLog(@"executing next task");
                [self executeNextTask:task.next];
            }
            else {
                // in case we have error - just report back to the dispatcher, no need to move to next task
                FlowerDispatcherTask* dispatcher = (FlowerDispatcherTask*)task.dispatcher;
                dispatch_group_leave(dispatcher.dispatchGroup);
            }
        }
    }
    else {
        if (error == nil) {
            if (task) {
                if ([task.taskId isEqualToString:self.end.taskId]) {
                    // this is the end task - complete with no error
                    NSLog(@"finishing after end task");
                    [self completedWithError:nil];
                }
                else if (task.next) {
                    NSLog(@"executing next task");
                    [self executeNextTask:task.next];
                }
                else {
                    NSLog(@"sequence ended with no next task");
                }
            }
            else {
                [self completedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData
                                          andMessage:kFlowerErrorTaskNotFound]];
            }
        }
        else {
            [self completedWithError:error];
        }
    }
}

-(void) task:(FlowerTask*)task progressChanged:(CGFloat)progress {
    if (task) {
        FlowerTaskMetadata* metadata = [self.tasksMetadata objectForKey:task.taskId];
        if (metadata) {            
            [self addToProgress:(progress * metadata.progressVolume)];
            [self notifyProgressChanged:self.progress];
        }
    }
}

@end