// Flower.h
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

#import "FlowerProcess.h"
#import "FlowerSeed.h"

/**
 * 'FlowerDelegate' protocol allows a class to be notified on running process state changes.
 */

@protocol FlowerDelegate <NSObject>

/**-----------------------------------------------------------------------------
 * @name Notifiying a process has finished with the updated data structure (FlowerSeed).
 * -----------------------------------------------------------------------------
 */
-(void) process:(FlowerProcess*)process finishedWithSeed:(FlowerSeed*)seed;


/**-----------------------------------------------------------------------------
 * @name Notifiying a process has failed with a specific error.
 * -----------------------------------------------------------------------------
 */
-(void) process:(FlowerProcess*)process failedWithError:(NSError*)error;

@optional

/**-----------------------------------------------------------------------------
 * @name Notifiying a process has started with a specific amount of tasks to perform.
 * -----------------------------------------------------------------------------
 */
-(void) process:(FlowerProcess*)process startedWithTaskCount:(NSInteger)tasksCount;

/**-----------------------------------------------------------------------------
 * @name Notifiying a process's progress has changed with the updated progress value.
 * -----------------------------------------------------------------------------
 */
-(void) process:(FlowerProcess*)process progressChanged:(CGFloat)progress;

@end


/**
 * 'Flower' class manages the execution of flower processes. Process objects
 * (defined by FlowerProcess class) are submitted to Flower for execution along with a process listener
 * (an object which implements the FlowerDelegate protocol) that Flower will use to send notifications to
 * when a process starts, finishes or fails, as well as when its progress changes.
 *
 * Each call to @see executeProcess:notify: will start an async process execution, returning a reference id
 * that can be later used to query Flower for a process state using @see processState: 
 * or to cancel a process using @see cancelProcessWithId:.
 * Several processes can run at the same time, by making several calls to @see executeProcess:notify:.
 */

@interface Flower : NSObject <FlowerProcessDelegate>

/**-----------------------------------------------------------------------------
 * @name Accessing a shared Flower instance.
 * -----------------------------------------------------------------------------
 *
 * @return The shared Flower instance, creating it if necessary.
 */
+(instancetype) flower;


/**-----------------------------------------------------------------------------
 * @name Executes a given process, keeping a delegation to use for notification on state changes.
 * -----------------------------------------------------------------------------
 *
 * @param process The process object to use for execution.
 * @param delegate The delegate object for the operation. The delegate will
 * receive delegate messages during execution of the process when state changes
 * and upon completion or failure of the process.
 * 
 */
-(NSString*) executeProcess:(FlowerProcess*)process notify:(id<FlowerDelegate>)delegate;


/**-----------------------------------------------------------------------------
 * @name Cancels a process identified by the process id.
 * -----------------------------------------------------------------------------
 *
 * @param processId The process id of the process needed to be cancelled.
 * @return Indication if cancellation was successful or not
 */
-(BOOL) cancelProcessWithId:(NSString*)processId;


/**-----------------------------------------------------------------------------
 * @name Queries for a process state identified by the process id.
 * -----------------------------------------------------------------------------
 *
 * @param processId The process id of the process queried for state.
 * @return State of the process (using FlowerProcessState enum)
 */
-(FlowerProcessState) processState:(NSString*)processId;

@end