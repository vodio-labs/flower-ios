//
//  LoadingView.h
//  Crave_IOS
//
//  Created by Nir Ninio on 10/4/15.
//  Copyright © 2015 Vodio Labs Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic) BOOL loading;

+(LoadingView*) instance;

-(void) startLoading:(BOOL)animated;
-(void) stopLoading:(BOOL)animated completion:(void(^)(void))completion;

@end