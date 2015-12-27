//
//  ICapitalService.h
//  Flower
//
//  Created by Nir Ninio on 27/12/2015.
//  Copyright © 2015 Nir Ninio. All rights reserved.
//

#ifndef ICapitalService_h
#define ICapitalService_h

#import <Foundation/Foundation.h>

@protocol ICapitalService <NSObject>

-(NSString*) urlForCity:(NSString*)city;
-(CGFloat) population:(NSInteger)population inArea:(NSInteger)area;

@end

#endif /* ICapitalService_h */