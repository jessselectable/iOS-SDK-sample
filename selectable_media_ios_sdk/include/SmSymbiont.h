//
//  SmSymbiont.h
//
//  Created by Jess Winter on 1/18/12.
//  Copyright (c) 2012 Selectable Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SmSymbiontDelegate.h"
#import "SmServerAPIDelegate.h"

#define SM_SDK_VERSION @"1.0"

@class SmConfig;
@class SmAdStore;
@class SmServerAPI;

@interface SmSymbiont : NSObject <SmServerAPIDelegate>

+ (SmSymbiont *)symbiontWithUser:(NSString *)user placement:(NSString *)placement publisherSuffix:(NSString *)publisherSuffix;

+ (SmSymbiont *)symbiontWithConfig:(SmConfig *)config;

+ (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@property(nonatomic, readonly) SmConfig *config;
@property(nonatomic, assign) NSObject <SmSymbiontDelegate> *delegate;

- (id)initWithConfig:(SmConfig *)config;

- (void)presentModalAdSelectorWithParentController:(UIViewController *)parentController animated:(BOOL)animated;

@end
