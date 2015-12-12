//
//  LoadingView.m
//  Crave_IOS
//
//  Created by Nir Ninio on 10/4/15.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

static LoadingView* _instance = nil;

-(instancetype) init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.loading = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

        activity.center = self.center;
        [activity startAnimating];
        [self addSubview:activity];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

+(LoadingView*) instance {
    if (_instance == nil) {
        _instance = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _instance;
}

-(void) startLoading:(BOOL)animated {
    
    if ([self superview] != [[UIApplication sharedApplication] keyWindow]) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    
    if (self.loading) {
        self.alpha = 1.0;
        return;
    }
    
    self.loading = YES;
    
    if (animated){
        self.alpha = 0.0;
        [UIView animateWithDuration:0.2
                         animations:^ { self.alpha = 1.0; }
                         completion:nil];
    }
    else {
        self.alpha = 1.0;
    }
}

-(void) stopLoading:(BOOL)animated completion:(void (^)(void))completion{
    if (!self.loading) {
        self.alpha = 0.0;
        [[LoadingView instance] removeFromSuperview];
        if (completion) { completion(); }
        return;
    }
    
    self.loading = NO;
    
    if (animated){
        self.alpha = 1.0;
        [UIView animateWithDuration:0.2
                         animations:^ { self.alpha = 0.0; }
                         completion:^ (BOOL finished) {
                             [[LoadingView instance] removeFromSuperview];
                             if (completion) { completion(); }
                         }];
    }
    else {
        self.alpha = 0.0;
        [[LoadingView instance] removeFromSuperview];
        if (completion) { completion(); }
    }
}

@end