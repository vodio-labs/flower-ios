//
//  FlowerError.h
//  Crave_IOS
//
//  Created by Nir Ninio on 09/12/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFlowerErrorRootNodeNotFound                @"root node is nil"
#define kFlowerErrorSeedNotFound                    @"seed is nil"
#define kFlowerErrorDelegateNotFound                @"delegate is not set"
#define kFlowerErrorProcessNotCreated               @"process is not in created state, not ready to run"
#define kFlowerErrorProcessNotRunningOrCancelled    @"process is not in running/cancelled state, can not continue"
#define kFlowerErrorTaskNotFound                    @"current task is"
#define kFlowerErrorTaskNotImplemented              @"task do work not implemented"

typedef NS_ENUM (NSUInteger, FlowerErrorCode) {
    FlowerErrorProcessStateNotValid,
    FlowerErrorInvalidData
};

@interface FlowerError : NSError

+(instancetype) errorWithCode:(NSInteger)code;
+(instancetype) errorWithCode:(NSInteger)code andMessage:(NSString*)message;

@end