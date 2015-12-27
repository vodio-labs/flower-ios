// FlowerProcess.h
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


#import <Foundation/Foundation.h>

#import "FlowerTask.h"
#import "FlowerSeed.h"


/** These constants indicate the type of states a process can go through its life cycle.
 *
 */
typedef NS_ENUM (NSInteger, FlowerProcessState) {
    
    /** Indicates the process doesn't even exist within Flower managed execution list.
     */
    PROCESS_NOT_EXIST,
    
    /** Indicates the process has been created, and should be ready to run.
     */
    PROCESS_CREATED,

    /** Indicates the process has started its execution, and should be able to process its tasks.
     */
    PROCESS_RUNNING,

    /** Indicates the process has finished execution.
     */
    PROCESS_FINISHED,

    /** Indicates the process has been cancelled.
     */
    PROCESS_CANCELLED
};


/**
 * 'FlowerProcessDelegate' protocol allows Flower to be notified on running process state changes.
 */

@protocol FlowerProcessDelegate <NSObject>

/**-----------------------------------------------------------------------------
 * @name Notifiying a process has started.
 * -----------------------------------------------------------------------------
 */
-(void) processStarted:(NSString*)processId;


/**-----------------------------------------------------------------------------
 * @name Notifiying a process's progress has changed with the updated progress value.
 * -----------------------------------------------------------------------------
 */
-(void) process:(NSString*)processId progressChanged:(CGFloat)progress;

/**-----------------------------------------------------------------------------
 * @name Notifiying a process has finished with the updated data structure (FlowerSeed) or Failed with Error.
 * -----------------------------------------------------------------------------
 */
-(void) process:(NSString*)processId didFinishWithSeed:(id)seed error:(NSError*)error;


/**-----------------------------------------------------------------------------
 * @name Notifiying a process has been cancelled with Error (optional).
 * -----------------------------------------------------------------------------
 */
-(void) process:(NSString*)processId didCancelWithError:(NSError*)error;

@end


/**
 * 'FlowerProcess' class manages a complete process to be executed by Flower.
 * FlowerProcess know to handle complex structure of tasks and can run a subset of tasks simultaneously if needed.
 * The process is build by adding tasks or sub processes in a row, or in parallel.
 * A process can state if it needs to block the user interface using the @see blocking property,
 * in case it does, Flower will do blocking until the process finishes (graying the screen and spinning the activity view in the middle).
 * A process can also state it needs to finish even if the app goes to the background using the @see completesInBackground property.
 * In that case Flower will ask the system to allow as much execution time as possible to finish the work.
 *
 * A process must have a seed to work with, this is how input and output works. It also has to have a root node
 * from which the execution of the process starts, and continues until it reaches the end node.
 *
 * Using the @see structure message will allow a process to print it all structure along with the correspondent metadata.
 *
 * Every subclass must implement the @see buildProcess message which inside it has to structure and orchestrate
 * the set of tasks / sub processes that take part in this process.
 *
 * Each call to @see dispatchAndNotifyDelegate: initiate a process run, validating it state first.
 * Calling @see cancel will stop the process after the current task is completed and return.
 */

@interface FlowerProcess : NSObject <FlowerTaskDelegate>


/**
 The current state (@see FlowerProcessState) of the process.
 */
@property (nonatomic, readonly) FlowerProcessState state;

/**
 The number of tasks this process is built from.
 */
@property (nonatomic, readonly) NSInteger tasksCount;


/**
 The data object (@see FlowerSeed) that this process expects to use.
 */
@property (nonatomic, strong) FlowerSeed* seed;

/**
 The root node of the tasks structure. This is the first executed task of this process.
 */
@property (nonatomic, strong, readonly) FlowerTask* root;

/**
 The end node of the tasks structure. This is the last node being executed before completing the whole process.
 */
@property (nonatomic, strong, readonly) FlowerTask* end;

/**
 The unique process identifier.
 */
@property (nonatomic, strong, readonly) NSString* identifier;

/**
 The current progress value of the process.
 */
@property (nonatomic, readonly) CGFloat progress;

/**
 Whether this process is blocking the user interface until completion.
 */
@property (nonatomic) BOOL blocking;

/**
 Whether this process completes in the background, and therefore needs the system support for that.
 */
@property (nonatomic) BOOL completesInBackground;

/**
 The background udentifier incase it goes into background completion mode.
 */
@property (nonatomic) UIBackgroundTaskIdentifier backgroundIdentifier;

/**
 The metadata objects of all the tasks within this process.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary* tasksMetadata;


/**-----------------------------------------------------------------------------
 * @name Instantiating a FlowerProcess instance with specific seed (FlowerSeed object).
 * -----------------------------------------------------------------------------
 *
 * @param seed The seed (FlowerSeed object) this process needs to work with (data structure)
 * @return A newly created FlowerProcess already built instance.
 */
-(instancetype) initWithSeed:(FlowerSeed*)seed;


/**-----------------------------------------------------------------------------
 * @name Instantiating a FlowerProcess instance with specific seed (FlowerSeed object).
 * -----------------------------------------------------------------------------
 *
 * @param seed The seed (FlowerSeed object) this process needs to work with (data structure).
 * @param buildable Whether this process is buildable yet or not.
 * @return A newly created FlowerProcess instance.
 *
 * @warning If you specify buildable = NO, you will later have to call to @see buildProcess before dispatching it.
 */
-(instancetype) initWithSeed:(FlowerSeed*)seed buildable:(BOOL)buildable NS_DESIGNATED_INITIALIZER;


/**-----------------------------------------------------------------------------
 * @name Printing the structure of a process, inclding its tasks and metatada.
 * -----------------------------------------------------------------------------
 *
 */
-(void) structure;


/**-----------------------------------------------------------------------------
 * @name Building a process by structuring its tasks and / or sub processes.
 * -----------------------------------------------------------------------------
 *
 */
-(void) buildProcess;


/**-----------------------------------------------------------------------------
 * @name Dispatching a process execution.
 * -----------------------------------------------------------------------------
 *
 * @param delegate The delegate that will be notified on process state changes.
 */
-(void) dispatchAndNotifyDelegate:(id<FlowerProcessDelegate>)delegate;

/**-----------------------------------------------------------------------------
 * @name Cancelling a process.
 * -----------------------------------------------------------------------------
 *
 */
-(void) cancel;


// ==================================================== //
// Building process methods
// ==================================================== //


/**-----------------------------------------------------------------------------
 * @name Creating a task based on the type of its class.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param taskClass The class type of the task to create.
 * @return The created task (@see FlowerTask).
 */
-(FlowerTask*) taskOf:(Class)taskClass;


/**-----------------------------------------------------------------------------
 * @name Creating a process based on the type of its class.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param processClass The class type of the process to create.
 * @param seed The data (@see FlowerSeed) this process will be working with.
 * @return The created process.
 */
-(FlowerProcess*) processOf:(Class)processClass withSeed:(FlowerSeed*)seed;


/**-----------------------------------------------------------------------------
 * @name Adding a task to the process tasks structure.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param taskClass The class type of the task to add - this will create the task first.
 * @param seed The data (@see FlowerSeed) this task will be working with.
 * @param progressVolume The part of the overall process progress this task will be doing.
 * @return The created task (@see FlowerTask).
 */
-(FlowerTask*) addTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;


/**-----------------------------------------------------------------------------
 * @name Adding a sub process to the process tasks structure.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param processClass The class type of the process to add - this will create the process and build it first.
 * @param seed The data (@see FlowerSeed) this task will be working with.
 * @param volume The part of the overall process progress this sub process will be doing.
 * @return The root task (@see FlowerTask) of the process.
 */
-(FlowerTask*) addProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;


/**-----------------------------------------------------------------------------
 * @name Adding parallel list of task to the process tasks structure.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param tasks An array of tasks.
 * @return The reference task (@see FlowerTask) of all the parallel tasks added.
 */
-(FlowerTask*) addParallelWithTasks:(NSArray*)tasks;


/**-----------------------------------------------------------------------------
 * @name Creating a parallel task based on the type of its class.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param taskClass The class type of the task to add - this will create the task first.
 * @param seed The data (@see FlowerSeed) this task will be working with.
 * @param volume The part of the overall process progress this task will be doing.
 * @return The created task (@see FlowerTask).
 */
-(FlowerTask*) parallelTaskOf:(Class)taskClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;


/**-----------------------------------------------------------------------------
 * @name Creating a parallel process based on the type of its class.
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param processClass The class type of the sub process to add - this will create and build the process first.
 * @param seed The data (@see FlowerSeed) this task will be working with.
 * @param volume The part of the overall process progress this task will be doing.
 * @return The root task (@see FlowerTask) of the sub process.
 */
-(FlowerTask*) parallelProcessOf:(Class)processClass withSeed:(FlowerSeed*)seed progressVolume:(CGFloat)volume;

@end