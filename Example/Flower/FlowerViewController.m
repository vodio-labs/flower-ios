//
//  FlowerViewController.m
//  Flower
//
//  Created by Nir Ninio on 12/10/2015.
//  Copyright (c) 2015 Nir Ninio. All rights reserved.
//

#import "FlowerViewController.h"
#import <Flower/Flower.h>
#import "ICapitalService.h"
#import "PopulationSeed.h"
#import "PopulationProcess.h"

#define CapitalCityUrl          @"https://restcountries.eu/rest/v1/capital/%@"
#define CountriesByRegionUrl    @"https://restcountries.eu/rest/v1/region/%@"

@interface FlowerViewController () <FlowerDelegate, ICapitalService>

@property (nonatomic, strong) UIProgressView* progressView;
@property (nonatomic, strong) UITextView* textView;

@end


@implementation FlowerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 40, screenWidth-40, 10)];
    _progressView.progress = 0.0;
    _progressView.progressTintColor = [UIColor greenColor];
    
    [self.view addSubview:_progressView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40+_progressView.frame.size.height,
                                                             screenWidth-40, screenHeight-60-_progressView.frame.size.height)];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.text = @"";
    
    [self.view addSubview:_textView];
    [self fetchCapitals:@"africa"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchCapitals:(NSString*)region {
    if (region) {
        NSString* url = [NSString stringWithFormat:CountriesByRegionUrl, region];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSMutableArray* cities = [NSMutableArray array];
        NSError* error;
        
        NSArray* json =
        [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (!error) {
            for (NSDictionary* country in json) {
                if (country && [country objectForKey:@"capital"]) {
                    [cities addObject:country[@"capital"]];
//                    if ([cities count] > 20) {
//                        break;
//                    }
                }
            }
        }
        
        if ([cities count] > 0) {
            PopulationProcess* pprocess = [[PopulationProcess alloc] initWithCapitalCities:cities andService:self];
            self.progressView.progress = 0.0;
            self.textView.text = @"";
            [[Flower flower] executeProcess:pprocess notify:self];
        }
        else {
            self.textView.text = @"no cities found";
        }
    }
}

#pragma mark - FlowerDelegate

-(void) process:(FlowerProcess*)process finishedWithSeed:(FlowerSeed*)seed {
    self.progressView.progress = 1.0;
    if (seed && [seed isKindOfClass:[PopulationSeed class]]) {
        PopulationSeed* pseed = (PopulationSeed*)seed;
        self.textView.text = [pseed.cities componentsJoinedByString:@"\n"];
    }
}

-(void) process:(FlowerProcess*)process failedWithError:(NSError*)error {
    self.progressView.progress = 1.0;
    self.textView.text = [error localizedDescription];
}

-(void) process:(FlowerProcess*)process startedWithTaskCount:(NSInteger)tasksCount {
    self.textView.text = [NSString stringWithFormat:@"started with : %ld tasks", (long)tasksCount];
}

-(void) process:(FlowerProcess*)process progressChanged:(CGFloat)progress {
    NSLog(@"progress changed: %f", progress);
    self.progressView.progress = progress;
}

#pragma mark - ICapitalService

-(NSString *)urlForCity:(NSString *)city {
    return city ? [NSString stringWithFormat:CapitalCityUrl, city] : nil;
}

-(CGFloat) population:(NSInteger)population inArea:(NSInteger)area {
    return area > 0 ? population / area : 1;
}

@end