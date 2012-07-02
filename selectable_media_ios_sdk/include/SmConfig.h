//
//  SmConfig.h
//
//  Created by Jess Winter on 1/20/12.
//  Copyright (c) 2012 Selectable Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmConfig : NSObject

+ (SmConfig *)smConfigWithUser:(NSString *)user placement:(NSString *)placement publisherSuffix:(NSString *)publisherSuffix;

+ (SmConfig *)smConfigWithUser:(NSString *)user publisherSuffix:(NSString *)publisherSuffix adList:(NSString *)adList; // only used for demos

+ (SmConfig *)smConfigWithUser:(NSString *)user publisherSuffix:(NSString *)publisherSuffix adList:(NSString *)adList settings:(NSDictionary *)settings; // only used for demos

+ (SmConfig *)smConfigWithUser:(NSString *)user publisherSuffix:(NSString *)publisherSuffix placement:(NSString *)placement settings:(NSDictionary *)settings;

@property(nonatomic, readonly) NSString *user;
@property(nonatomic, readonly) NSString *placement;
@property(nonatomic, readonly) NSString *publisherSuffix;
@property(nonatomic, readonly) NSDictionary *settings;
@property(nonatomic, readonly) NSString *adList; // only used for demos

- (id)initWithUser:(NSString *)user placement:(NSString *)placement publisherSuffix:(NSString *)publisherSuffix adList:(NSString *)adList settings:(NSDictionary *)settings;

@end
