//
//  Game.h
//  BalloonGameTutorial
//
//  Created by Johann Dowa of ManiacDev.com
//  Copyright Johann Dowa 2010. All rights reserved.
//
//  You may use this code within your own games.  In fact I encourage it, and if
//  you provide credit somewhere in your game to myself and ManiacDev.Com tell
//  me about it and I'll mention it on my ManiacDev.Com which receives thousands 
//  of daily visits.
// 
//  You may however not use this code or any portion for any use other than in
//  the development of iOS applications without my permission. 
//  (In other words you may not use it in any tutorials, books wikis etc. 
//  without asking me first)
// 
#import <Foundation/Foundation.h>

@protocol VideoWallInvokedDelegate;
@interface Game : SPStage {
	SPTextField *scoreTextField;
	SPTextField *levelTextField;
	SPTextField *livesTextField;
	NSMutableArray *balloonTextures;
	SPSprite *playFieldSprite;
	BOOL resetButtonVisible;
	BOOL balloonIsVisible;
	SPView *view;
	
	id <VideoWallInvokedDelegate> delegate;
}
- (id)initWithWidthAndValues:(float)width height:(float)height lives:(int)lives score:(int)score  level:(int)level showButton:(BOOL)showButton;
- (id)initWithWidthAndButton:(float)width height:(float)height showButton:(BOOL)showButton;


-(void)addBalloon;
-(void)onTouchBalloon:(SPTouchEvent*)event;
-(void)movementThroughTopOfScreen:(SPEvent*)event;
-(void)drawBalloons;
-(void)balloonPopped:(SPEvent*)event;
-(void)onResetButtonTriggered:(SPEvent*)event;
-(void)updateTextLabels;

@property (readwrite,assign) int score;
@property (readwrite,assign) int level;
@property (readwrite,assign) int lives;

@property (nonatomic, retain) id <VideoWallInvokedDelegate> delegate;

@end

@protocol VideoWallInvokedDelegate <NSObject>
@required
- (void)buttonClicked;
@end
