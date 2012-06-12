//
//  SmSymbiontDelegate.h
//
//  Created by Jess Winter on 1/18/12.
//  Copyright (c) 2012 Selectable Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SmSymbiont;

@protocol SmSymbiontDelegate <NSObject>

@required
- (void)smSymbiontDidCloseAdSelectorView:(SmSymbiont *)symbiont;

@end
