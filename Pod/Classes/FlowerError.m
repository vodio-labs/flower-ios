//
//  FlowerError.m
//  Crave_IOS
//
//  Created by Nir Ninio on 09/12/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerError.h"

@implementation FlowerError

+(instancetype) errorWithCode:(NSInteger)code {
    return [self errorWithCode:code andMessage:nil];
}

+(instancetype) errorWithCode:(NSInteger)code andMessage:(NSString*)message {
    
    NSDictionary* userInfo = nil;
    if (message && [message isKindOfClass:[NSString class]]) {
        userInfo = @ {
            NSLocalizedDescriptionKey: NSLocalizedString(message, nil)
        };
    }
    return [self errorWithDomain:@"com.Flower.ErrorDomain" code:code userInfo:userInfo];
}

@end