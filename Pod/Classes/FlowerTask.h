// FlowerTask.h
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
#import "FlowerSeed.h"

@class FlowerTask;


/**
 * 'FlowerTaskDelegate' protocol allows a class to be notified when tasks progress changes and when it ends.
 */

@protocol FlowerTaskDelegate <NSObject>

/**-----------------------------------------------------------------------------
 * @name Notifiying a task's progress has changed with updated progress value.
 * -----------------------------------------------------------------------------
 */
-(void) task:(FlowerTask*)task progressChanged:(CGFloat)progress;


/**-----------------------------------------------------------------------------
 * @name Notifiying a task has finished successfully or with error.
 * -----------------------------------------------------------------------------
 */
-(void) task:(FlowerTask*)task finishedWithError:(NSError*)error;

@end



/**
 * 'FlowerTask' class manages a specific task responsible for a small unit of work, usually part of a process (@see FlowerProcess)
 * along with other tasks.
 *
 * Calling @see runWithSeed: will let the task perform it job with the supplied seed (@see FlowerSeed).
 * Calling @see cancel will cancel the run of the task if supported.
 *
 * @warning A Task must call taskFinishedWithError: when it finishes its work, so that its process with be able to handle and 
 * orchestrate next move. If an error occured, the task must supply it as input, so that the process will know it failed.
 *
 */

@interface FlowerTask : NSObject


/**
 The task unique id.
 */
@property (nonatomic, strong, readonly) NSString* taskId;


/**
 The name of the task.
 */
@property (nonatomic, strong, readonly) NSString* name;


/**
 The delegate of this task, will be receiving notifications on tasks state changes.
 */
@property (nonatomic, weak) id<FlowerTaskDelegate> delegate;


/**
 The seed (@see FlowerSeed) object this task works with.
 */
@property (nonatomic, strong, readonly) FlowerSeed* seed;


/**
 The updated progress value of this task.
 */
@property (nonatomic) CGFloat progress;


/**
 The error of this task if such occur during running.
 */
@property (nonatomic, strong, readonly) NSError* error;


/**
 A pointer to the next serial task.
 */
@property (nonatomic, strong) FlowerTask* next;


/**
 The task which dispatched this task (parallel), if such exists.
 */
@property (nonatomic, weak) FlowerTask* dispatcher;


/**-----------------------------------------------------------------------------
 * @name Instantiating a FlowerTask instance with specific delegate.
 * -----------------------------------------------------------------------------
 *
 * @param delegate The delegate (@see FlowerTaskDelegate) this tasks uses to notify on state changes.
 * @return A newly created FlowerTask instance.
 */
-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate;


/**-----------------------------------------------------------------------------
 * @name Instantiating a FlowerTask instance with specific name and delegate.
 * -----------------------------------------------------------------------------
 *
 * @param name The name of this task.
 * @param delegate The delegate (@see FlowerTaskDelegate) this tasks uses to notify on state changes.
 * @return A newly created FlowerTask instance.
 */
-(instancetype)initWithName:(NSString*)name
                andDelegate:(id<FlowerTaskDelegate>)delegate NS_DESIGNATED_INITIALIZER;


/**-----------------------------------------------------------------------------
 * @name Returning this task description.
 * -----------------------------------------------------------------------------
 *
 * @return A string representing the task name and id.
 */
-(NSString*) taskDescription;


/**-----------------------------------------------------------------------------
 * @name Running the task with a specific seed (@see FlowerSeed).
 * -----------------------------------------------------------------------------
 *
 * @param seed The seed (FlowerSeed object) this task needs to work with (data structure).
 */
-(void) runWithSeed:(FlowerSeed*)seed;


/**-----------------------------------------------------------------------------
 * @name Cancelling a running task.
 * -----------------------------------------------------------------------------
 *
 * @warning A Task must call its super cancel after implementing its own cancel logic
 */
-(void) cancel;


/**-----------------------------------------------------------------------------
 * @name Finishing a task with success of failure.
 * -----------------------------------------------------------------------------
 *
 * @param error An error if such occur during task run.
 */
-(void) taskFinishedWithError:(NSError*)error;

@end