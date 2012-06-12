//
//  SelectableMediaGameAppDelegate.m
//  SelectableMediaGame
//
//  Copyright 2012 Selectable Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectableMediaGameViewController;

@interface SelectableMediaGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SelectableMediaGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SelectableMediaGameViewController *viewController;

@end

