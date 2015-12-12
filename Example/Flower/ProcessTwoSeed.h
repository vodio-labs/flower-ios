//
//  ProcessTwoSeed.h
//  Crave_IOS
//
//  Created by Nir Ninio on 18/11/2015.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "FlowerSeed.h"
#import "ProcessOneSeed.h"

@interface ProcessTwoSeed : FlowerSeed

@property (nonatomic, strong) NSString* taskFourChecked;
@property (nonatomic, strong) NSString* taskFiveChecked;
@property (nonatomic, strong) NSString* taskSixChecked;
@property (nonatomic, strong) NSString* taskSevenChecked;
@property (nonatomic, strong) NSString* taskEightChecked;
@property (nonatomic, strong) NSString* taskNineChecked;
@property (nonatomic, strong) NSString* taskTenChecked;

@property (nonatomic, strong) ProcessOneSeed* oneSeed;
@property (nonatomic, strong) ProcessOneSeed* parallerOneSeed;

-(void) log;

@end
