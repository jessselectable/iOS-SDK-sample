//
//  SmServerAPIDelegate.h
//
//  Created by Jess Winter on 1/26/12.
//  Copyright (c) 2012 Selectable Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SmAdResponseModel;

@protocol SmServerAPIDelegate <NSObject>

- (void)adsRequestResponse:(SmAdResponseModel *)response;

@end
