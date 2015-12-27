// FlowerError.h
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

/** This constant indicates the Flower error domain used by all Flower error instances
 */
#define FlowerErrorDomain @"io.vod.Flower.ErrorDomain"


/** These constants indicate the error messages results from a process's failure.
 *
 * Error messages are localized before use, so the actual message text can be used as a key 
 * in localized stringsto have the error in other languages as well.
 */

#define kFlowerErrorRootNodeNotFound                @"Root node is nil."
#define kFlowerErrorSeedNotFound                    @"Seed is nil."
#define kFlowerErrorDelegateNotFound                @"Delegate is not set."
#define kFlowerErrorProcessNotCreated               @"Process is not in created state, not ready to run."
#define kFlowerErrorProcessNotRunningOrCancelled    @"Process is not in running/cancelled state, can not continue."
#define kFlowerErrorTaskNotFound                    @"Task is not valid."
#define kFlowerErrorTaskNotImplemented              @"Task doWork message not implemented."


/** These constants indicate the type of error codes results from a process's failure.
 *
 */
typedef NS_ENUM (NSUInteger, FlowerErrorCode) {
    /** Indicates the state of the process is not valid during a process execution.
     */
    FlowerErrorProcessStateNotValid,
    
    /** Indicates the data is invalid for a specific task to perform its part inside a process.
     */
    FlowerErrorInvalidData
};

/**
 * 'FlowerError' class is a subclass of NSError which identifies a specific Flower error occured.
 *
 * Every error returned from Flower is from type FlowerError and can specify the type of the error
 * and the related message.
 */

@interface FlowerError : NSError

/**-----------------------------------------------------------------------------
 * @name Creating a FlowerError instance
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param code The error code to instatiate the FlowerError with.
 * @return The FlowerError instance with a specific error code.
 */
+(instancetype) errorWithCode:(NSInteger)code;


/**-----------------------------------------------------------------------------
 * @name Creating a FlowerError instance
 * -----------------------------------------------------------------------------
 */

/**
 *
 * @param code The error code to instatiate the FlowerError with.
 * @param message The error message to instantiate the FlowerError with.
 * @return The FlowerError instance with a specific error code and error message.
 */
+(instancetype) errorWithCode:(NSInteger)code andMessage:(NSString*)message;

@end