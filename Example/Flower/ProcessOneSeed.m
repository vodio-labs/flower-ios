//
//  ProcessOneSeed.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "ProcessOneSeed.h"

@implementation ProcessOneSeed

- (void)setTaskOneChecked:(NSString *)taskOneChecked {
    _taskOneChecked = taskOneChecked;
    [self log];
}

- (void)setTaskTwoChecked:(NSString *)taskTwoChecked {
    _taskTwoChecked = taskTwoChecked;
    [self log];
}

- (void)setTaskThreeChecked:(NSString *)taskThreeChecked {
    _taskThreeChecked = taskThreeChecked;
    [self log];
}

-(void) log {
    NSLog(@"one: %@, two: %@, three %@",
         self.taskOneChecked ?: @"NO",
         self.taskTwoChecked ?: @"NO",
         self.taskThreeChecked ?: @"NO");
}

@end