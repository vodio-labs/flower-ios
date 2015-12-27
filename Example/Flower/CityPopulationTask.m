//
//  CityPopulationTask.m
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#import "CityPopulationTask.h"
#import <Flower/FlowerError.h>
#import "CitySeed.h"


@implementation CityPopulationTask

-(instancetype)initWithDelegate:(id<FlowerTaskDelegate>)delegate {
    if(self = [super initWithName:@"City Population" andDelegate:delegate]) {
        
    }
    return self;
}

-(void) doWork {
    
    if (self.seed && [self.seed isKindOfClass:[CitySeed class]]) {
        
        CitySeed* cseed = (CitySeed*)self.seed;
        
        NSString* url = [self serviceUrlForCountry:cseed.name];
        
        if (url) {
            NSInteger pop = 0;
            NSInteger ar = 0;
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            if (data) {
                NSError* error;
                NSArray* json =
                [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (!error && [json count] >= 1) {
                    NSDictionary* capital = [json objectAtIndex:0];
                    if (capital && [capital isKindOfClass:[NSDictionary class]]) {
                        NSNumber* population = [capital objectForKey:@"population"];
                        if (population && [population isKindOfClass:[NSNumber class]]) {
                            pop = [population integerValue];
                        }
                        
                        NSNumber* area = [capital objectForKey:@"area"];
                        if (area && [area isKindOfClass:[NSNumber class]]) {
                            ar = [area integerValue];
                        }
                    }
                }
            }
            else {
                NSLog(@"data is nil for: %@", url);
            }
            
            if (pop == 0) {
                [self taskFinishedWithError:
                 [FlowerError errorWithCode:FlowerErrorInvalidData andMessage:@"response json is not valid"]];
                
                return; // nothing to do more
            }
            
            cseed.populationCalculated = [self population:pop inArea:ar]; // use the service
            [self taskFinishedWithError:nil]; // we finished successfully
        }
        else {
            [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData andMessage:@"url is not valid"]];
        }
    }
    else {
        [self taskFinishedWithError:[FlowerError errorWithCode:FlowerErrorInvalidData andMessage:@"city seed is not valid"]];
    }
}

@end