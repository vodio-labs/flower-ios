//
//  FlowerProcessDelegate.h
//  Crave_IOS
//
//  Created by Nir Ninio on 19/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flower.h"

@interface FlowerProcessDelegate : NSObject <FlowerDelegate>

@property (nonatomic, strong, readonly) NSString* processId;

-(instancetype) initWithProcessId:(NSString*)processId;

@end