//
//  FlowerTests.m
//  FlowerTests
//
//  Created by Nir Ninio on 12/10/2015.
//  Copyright (c) 2015 Nir Ninio. All rights reserved.
//

// https://github.com/Specta/Specta

#import "TestProcessOne.h"
#import "FlowerProcessListener.h"

SpecBegin(Flower)

describe(@"Flower", ^{
   
    __block TestProcessOne* process1 = nil;
    __block TestProcessOne* process2 = nil;
    __block TestProcessOne* process1bad = nil;
    __block TestProcessOne* process2bad = nil;
    __block TestProcessOne* processInvalidSeed = nil;
    
    beforeAll(^{
        process1 = [[TestProcessOne alloc] initWithTextOne:@"one text"];
        process2 = [[TestProcessOne alloc] initWithTextSecond:@"second text"];
        
        process1bad = [[TestProcessOne alloc] initWithTextOne:nil];
        process2bad = [[TestProcessOne alloc] initWithTextSecond:nil];
        
        processInvalidSeed = [[TestProcessOne alloc] initWithSeed:nil];
    });
    
    beforeEach(^{
        
    });
    
    it(@"process1 should have 2 tasks", ^{
        expect(process1.tasksCount).to.equal(2);
        expect(process1.state).to.equal(PROCESS_CREATED);
    });
    
    it(@"process1 seed should be of type TestSeedOne", ^ {
        expect(process1.seed).to.beInstanceOf([TestSeedOne class]);
    });
    
    it(@"process1 seed should be valid", ^ {
        
        TestSeedOne* seedOne = (TestSeedOne*)process1.seed;
        
        expect(seedOne.firstSeed).to.beInstanceOf([TestDataSeed class]);
        expect(seedOne.firstSeed.dataItemOne).to.equal(@"one text");
        expect(seedOne.firstSeed.dataItemTwo).to.beNil();
        expect(seedOne.secondSeed).to.beInstanceOf([TestDataSeed class]);
        expect(seedOne.secondSeed.dataItemOne).to.beNil();
        expect(seedOne.secondSeed.dataItemTwo).to.beNil();
    });

    it(@"process2 should have 2 tasks", ^{
        expect(process2.tasksCount).to.equal(2);
    });

    it(@"process2 seed should be valid", ^ {
        
        TestSeedOne* seedOne = (TestSeedOne*)process2.seed;
        
        expect(seedOne.firstSeed).to.beInstanceOf([TestDataSeed class]);
        expect(seedOne.firstSeed.dataItemOne).to.beNil();
        expect(seedOne.firstSeed.dataItemTwo).to.beNil();
        expect(seedOne.secondSeed).to.beInstanceOf([TestDataSeed class]);
        expect(seedOne.secondSeed.dataItemOne).to.equal(@"second text");
        expect(seedOne.secondSeed.dataItemTwo).to.beNil();
    });
    
    it(@"process1bad should have 0 tasks", ^{
        expect(process1bad.tasksCount).to.equal(0);
    });

    it(@"process2bad should have 0 tasks", ^{
        expect(process2bad.tasksCount).to.equal(0);
    });
    
    it(@"processInvalidSeed should have 0 tasks", ^{
        expect(processInvalidSeed.tasksCount).to.equal(0);
    });
    
    it(@"running process 1", ^ {
        FlowerProcessListener* listener = [[FlowerProcessListener alloc] initWithProcessId:process1.identifier];
        [[Flower flower] executeProcess:process1 notify:listener];
        
        expect(listener.processId).to.equal(process1.identifier);
        expect(listener.tasksCount).to.equal(2);

        expect(listener.progress).after(3).to.equal(1.0);
        expect(listener.error).after(3).to.beNil();
        expect(process1.state).after(3).to.equal(PROCESS_FINISHED);
        expect(((TestDataSeed*)((TestSeedOne*)process1.seed).firstSeed).dataItemOne).after(3).toNot.equal(@"one text");
        
    });
    
    it(@"running process 2", ^ {
        FlowerProcessListener* listener = [[FlowerProcessListener alloc] initWithProcessId:process2.identifier];
        [[Flower flower] executeProcess:process2 notify:listener];
        
        expect(listener.processId).to.equal(process2.identifier);
        expect(listener.tasksCount).to.equal(2);
        
        expect(listener.progress).after(3).to.equal(1.0);
        expect(listener.error).after(3).to.beNil();
        expect(process1.state).after(3).to.equal(PROCESS_FINISHED);
        expect(((TestDataSeed*)((TestSeedOne*)process1.seed).secondSeed).dataItemOne).after(3).toNot.equal(@"second text");
        
    });
});

SpecEnd