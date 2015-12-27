// LoadingView.m
// Copyright © 2015 Vodio Labs Ltd. (http://www.vod.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


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