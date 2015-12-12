//
//  ProcessTwoSeed.m
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "ProcessTwoSeed.h"

@implementation ProcessTwoSeed

-(instancetype) init {
    if (self = [super init]) {
        _oneSeed = [[ProcessOneSeed alloc] init];
        _parallerOneSeed = [[ProcessOneSeed alloc] init];
    }
    return self;
}


- (void)setTaskFourChecked:(NSString*)checked {
    _taskFourChecked = checked;
    [self log];
}

- (void)setTaskFiveChecked:(NSString*)checked {
    _taskFiveChecked = checked;
    [self log];
}

- (void)setTaskSixChecked:(NSString*)checked {
    _taskSixChecked = checked;
    [self log];
}

- (void)setTaskSevenChecked:(NSString*)checked {
    _taskSevenChecked = checked;
    [self log];
}

- (void)setTaskEightChecked:(NSString*)checked {
    _taskEightChecked = checked;
    [self log];
}

- (void)setTaskNineChecked:(NSString*)checked {
    _taskNineChecked = checked;
    [self log];
}

- (void)setTaskTenChecked:(NSString*)checked {
    _taskTenChecked = checked;
    [self log];
}

-(void) log {
    NSLog(@"four: %@, five: %@, six: %@, seven: %@, eight: %@, nine: %@, ten: %@",
         self.taskFourChecked ?: @"NO",
         self.taskFiveChecked ?: @"NO",
         self.taskSixChecked ?: @"NO",
         self.taskSevenChecked ?: @"NO",
         self.taskEightChecked ?: @"NO",
         self.taskNineChecked ?: @"NO",
         self.taskTenChecked ?: @"NO");

    [self.oneSeed log];
    [self.parallerOneSeed log];
}

@end