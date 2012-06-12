//
//  SelectableMediaGameAppDelegate.m
//  SelectableMediaGame
//
//  Copyright 2012 Selectable Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

#import "SelectableMedia.h"

@interface SelectableMediaGameViewController : UIViewController <VideoWallInvokedDelegate, SmSymbiontDelegate> {
	IBOutlet SPView *spView;
	UIView *videoWall;

	// We cache those values to set them when loading the game again.
	int lives;
	int score;
	int level;

	BOOL videosAvailable;
    
    SmSymbiont *symbiont;
}

@property (nonatomic, retain) IBOutlet SPView *spView;

-(void)startGame;
-(void)stopGame;
-(void)videosForUser;

@end

