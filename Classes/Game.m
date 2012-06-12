//
//  Game.m
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

#import "Game.h" 

@implementation Game

@synthesize score;
@synthesize level;
@synthesize lives;

@synthesize delegate;


// this is the initialization method executed to create the game scene
// normally it would be best not to do so much within your initialization method
// but I have here to make this code easier to follow.  We use it here to set
// up all the elements required to start the game, and begin the music.
- (id)initWithWidth:(float)width height:(float)height {
	return  [[Game alloc] initWithWidthAndValues:width height:height lives:2 score:0 level:1 showButton:TRUE];
}

- (id)initWithWidthAndButton:(float)width height:(float)height showButton:(BOOL)showButton {
	return  [[Game alloc] initWithWidthAndValues:width height:height lives:2 score:0 level:1 showButton:showButton];
}

- (id)initWithWidthAndValues:(float)width height:(float)height lives:(int)livesArg score:(int)scoreArg  level:(int)levelArg showButton:(BOOL)showButton {
	// initialize game stage with specified width and height
    if (self = [super initWithWidth:width height:height]) 
	{
		// Create image with contents of background image
		SPImage *backgroundImage = [SPImage imageWithContentsOfFile:@"background.png"];
		// add background image to the main stage
		[self addChild:backgroundImage];
		
		// set lives to 2, if we want to increase our lives we must watch a video
		lives = livesArg <= 0 ? 2 : livesArg;
		// set the score to zero
		score = scoreArg <= 0 ? 0 : scoreArg;
		// set the level to one
		level = levelArg <= 0 ? 1 : levelArg;
		// Create the score and level text fields
		scoreTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Score: %d", score]];
		levelTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Level: %d", level]];
		livesTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Lifes: %d", lives]];
		
		// set the font
		scoreTextField.fontName = @"Marker Felt";
		// set the x coordinates
		scoreTextField.x = 160;
		// set the y coordinates
		scoreTextField.y = 7;
		// set the vertical alignment to place text at the top
		scoreTextField.vAlign = SPVAlignTop;
		// align the text with the right of the text field
		scoreTextField.hAlign = SPHAlignRight;
		// set the font size
		scoreTextField.fontSize = 20;
		
		// add the score text to the stage
		[self addChild:scoreTextField];
		
		// do what we just did with score text field to the level
		// just place it on the other corner
		levelTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Level: %d", level]];
		levelTextField.fontName = @"Marker Felt";
		levelTextField.x = 10;
		levelTextField.y = 7;
		levelTextField.vAlign = SPVAlignTop;
		levelTextField.hAlign = SPHAlignLeft;
		levelTextField.fontSize = 20;
		
		[self addChild:levelTextField];
		
		// lifes section
		livesTextField = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Lives: %d", lives]];
		livesTextField.fontName = @"Marker Felt";
		livesTextField.x = 80;
		livesTextField.y = 7;
		livesTextField.vAlign = SPVAlignTop;
		livesTextField.hAlign = SPHAlignCenter;
		livesTextField.fontSize = 20;
		
		[self addChild:livesTextField];
		
		if (showButton == TRUE) {
			// VideoWall button
			SPButton *videoWallButton = [SPButton buttonWithUpState:[SPTexture textureWithContentsOfFile:@"reset_button.png"]];
			videoWallButton.x = self.width - videoWallButton.width;
			videoWallButton.y = self.height - videoWallButton.height;
			// set the font attributes
			videoWallButton.fontName = @"Marker Felt";
			videoWallButton.fontSize = 13;
			// add the button text
			videoWallButton.text = @"More lives?";
			[videoWallButton addEventListener:@selector(onVideoWallButtonTriggered:) atObject:self
									  forType:SP_EVENT_TYPE_TRIGGERED];
		
			[self addChild:videoWallButton];
		}
		
		// add the score text to the stage
		SPSound *music = [SPSound soundWithContentsOfFile:@"music.caf"];
		// create channel from music so we can make adjustments and retain so
		// music stays
		SPSoundChannel *channel = [[music createChannel] retain];
		// make the channel loop
		channel.loop = YES;
		// reduce volume of music to one quarter
		channel.volume = 0.25;
		// play music channel
		[channel play];
		
		// Create a mutable array for the image textures
		balloonTextures = [NSMutableArray array];
		
		// Add each of the balloon textures into the balloon textures array
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"blue.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"green.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"indigo.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"orange.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"red.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"violet.png"]];
		[balloonTextures addObject:[SPTexture textureWithContentsOfFile:@"yellow.png"]];
		// retain the balloon textures array so that it can be accessed
		// from elsewhere within this class
		[balloonTextures retain];
		
		// create sprite for the balloons to be placed in - I did this so that
		// objects on the playing field could be removed quickly without affecting
		// the background
		playFieldSprite = [SPSprite sprite];
		// add the playing field to the stage
		[self addChild:playFieldSprite];
		// draw the initial balloon onto the playfield
		[self drawBalloons];
	}
		
	return self;
}

// in this method we add a balloon and begin it's upward movement we'll simply
// take one and place it at a random location under the bottom of the screen
// and send it upwards to a random location at the top of the screen
-(void)addBalloon
{	
	// create image using a random balloon image
	SPImage *image = [SPImage imageWithTexture:[balloonTextures objectAtIndex:arc4random() % balloonTextures.count]];
	// place image at a random x coordinate
	image.x = (arc4random() % (int)(self.width-image.width));
	// place image just below the bottom of the screen
	image.y = self.height;
	
	// add image to the playing field
	[playFieldSprite addChild:image];
	
	// create an animation known as a tween with a duration between 2 and 6
	// seconds	
	SPTween *tween = [SPTween tweenWithTarget:image
										 time:(double)((arc4random() % 5) + 2)
								   transition:SP_TRANSITION_LINEAR];
	// set the x coordinate at the end of the animation to a random location
	[tween animateProperty:@"x" targetValue:arc4random() % (int)(self.width-image.width)];
	// set the y coordinate at the end of the animation to the point where the
	// balloon is just off the screen
	[tween animateProperty:@"y" targetValue:-image.height];
	// add this animation to the stage's "juggler" the juggler handles
	// animation timing, and every display object has one.  In this tutorial
	// we will exclusively be using the juggler for the main stage
	[self.juggler addObject:tween];
	
	// add a listener to the image of type SP_EVENT_TYPE_TOUCH so that when the
	// image is touched the onTouchBalloon method is executed
	[image addEventListener:@selector(onTouchBalloon:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	// add a listener so that when this animation is completed the movementDone
	// method is executed
	[tween addEventListener:@selector(movementThroughTopOfScreen:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
}

// this method is executed when a balloon is touched. the SPTouchEvent allows
// use to tell what phase the touch is in, we will only be looking at 
// SPTouchPhaseBegan as the balloons will drop immediately when touched.
// we also don't want the user to simply be able to slide their finger around to
// destroy all the balloons.
-(void)onTouchBalloon:(SPTouchEvent*)event
{
	
	// cast the event target as a display object so that we can manipulate it.
	SPDisplayObject* currentBalloon = (SPDisplayObject*)[event target];
	
	// remove all event listeners related to touch from this balloon		
	[currentBalloon removeEventListener:@selector(onTouchBalloon:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	
	// increase the score	
	score+=10;
	
	// update the score text
	scoreTextField.text = [NSString stringWithFormat:@"Score: %d", score];
	
	// play the balloon popping sound - this is the easiest way to play a
	// sound in Sparrow and for our purposes does just fine.
	[[SPSound soundWithContentsOfFile:@"balloonpop.caf"] play];
	
	// remove all animations from the stage juggler that are associated with
	// the touched balloon	
	[self.juggler removeTweensWithTarget:currentBalloon];
	
	// create a new animation within which we will adjust the scale of the
	// balloon to make it look like it has been deflated.
	SPTween *tween = [SPTween tweenWithTarget:currentBalloon time:0.35 transition:SP_TRANSITION_LINEAR];
	// adjust the scaling factor of the balloon's x coordinates
	[tween animateProperty:@"scaleX" targetValue:0.75];
	// adjust the scaling factor of the balloon's x coordinates
	[tween animateProperty:@"scaleY" targetValue:1.25];
	// add the new animation to the juggler
	[self.juggler addObject:tween];
	
	// create a new animation which will quickly move the balloon downwards
	// so it will look like it is falling due to a loss of air
	// scale things so that the animation speed stays consistent wherever
	// the balloon is on the screen.	
	tween = [SPTween tweenWithTarget:currentBalloon time:(480.0-currentBalloon.y)/480.0 transition:SP_TRANSITION_LINEAR];
	// set the ending y coordinate for the balloon off the bottom of the screen
	[tween animateProperty:@"y" targetValue:self.height+currentBalloon.height];
	// add the falling animation ot the juggler
	[self.juggler addObject:tween];
	
	// add an event listener that will run the balloon popped event as soon as
	// when the falling animation has completed.
	[tween addEventListener:@selector(balloonPopped:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];

}

// this method is used to draw more balloons on the screne based on the player's
// level
-(void)drawBalloons
{
	// loop until all balloons are drawn as determined by the current level
	for(int i = 0; i < level; i++)
	{
		// add balloon into the game
		[self addBalloon];
	}

	balloonIsVisible = NO;
}

// this is the method that executes whenever a ballon has exited the screen
// we are going to stop all animations, dim the screen by overlaying a
// semi-transparent graphic, and add a reset button
-(void)movementThroughTopOfScreen:(SPEvent*)event
{
	if (balloonIsVisible == NO) {
		balloonIsVisible = YES;
		lives--;
		livesTextField.text = [NSString stringWithFormat:@"Lives: %d", lives];

		if (lives == 0) {
			// we'll use reset button visible as when more than one object leaves the
			// screen at the same time this can cause the code in this method to execute
			// multiple times
			if(resetButtonVisible == NO)
			{
				resetButtonVisible = YES;
				// darken the screen with a semi-transparent overlay this has the added
				// effect of covering up touches to objects behind it
				SPImage *backgroundImage = [SPImage imageWithContentsOfFile:@"screen_overlay.png"];
				// add background image to the main stage
				[playFieldSprite addChild:backgroundImage];

				// create a reset button using the reset button graphic
				SPButton *resetButton = [SPButton buttonWithUpState:[SPTexture textureWithContentsOfFile:@"reset_button.png"]];
				// place the button in the middle of the screen
				resetButton.x = self.width/2-resetButton.width/2;
				resetButton.y = self.height/2-resetButton.height/2;
				// set the font attributes
				resetButton.fontName = @"Marker Felt";
				resetButton.fontSize = 20;
				// add the button text
				resetButton.text = @"Reset Game";
				// add a listener so that when the button is pressed the
				// onResetButtonTriggered method is executed
				[resetButton addEventListener:@selector(onResetButtonTriggered:) atObject:self
									  forType:SP_EVENT_TYPE_TRIGGERED];

				// add the button to the playing field
				[playFieldSprite addChild:resetButton];
			}
		} else {
			SPImage *backgroundImage = [SPImage imageWithContentsOfFile:@"screen_overlay.png"];
			[playFieldSprite addChild:backgroundImage];
			
			SPButton *resetButton = [SPButton buttonWithUpState:[SPTexture textureWithContentsOfFile:@"reset_button.png"]];
			resetButton.x = self.width/2-resetButton.width/2;
			resetButton.y = self.height/2-resetButton.height/2;
			resetButton.fontName = @"Marker Felt";
			resetButton.fontSize = 20;
			resetButton.text = @"Continue";
			[resetButton addEventListener:@selector(onContinueButtonTriggered:) atObject:self
								  forType:SP_EVENT_TYPE_TRIGGERED];
			[playFieldSprite addChild:resetButton];
		}
	}
}

// this method is executed whenever a falling balloon flies through the bottom
// of the screen when no more ballooons are visible this method will increase
// the level so that a greater number of balloons can be drawn and perform
// cleanup on the playing field
-(void)balloonPopped:(SPEvent*)event
{	
	// take the event and get the animation (tween) from it
	SPTween *animation = (SPTween*)[event target];
	
	[animation removeEventListener:@selector(balloonPopped:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
	
		// get the balloon that is attached to the animatio
	SPDisplayObject *currentBalloon = (SPDisplayObject*)[animation target];
	
	// remove the balloon from the playing field
	[playFieldSprite removeChild:currentBalloon];
	
	// if there are no balloons visible execute this code
	if(playFieldSprite.numChildren == 0)
	{
		// increase the level
		level++;
		// update the level text
		levelTextField.text = [NSString stringWithFormat:@"Level: %d", level];
		
		// empty the playing field of ballons which are now off the screen
		[playFieldSprite removeAllChildren]; 
		
		// redraw the balloons
		[self drawBalloons];
	}
	
	
}
	
// this method is executed once the reset button is pressed and we will 
// use it here in order to do some cleanup and restart the game
-(void)onResetButtonTriggered:(SPEvent*)event
{
	// remove any balloons remaining on the play field to clean up memory	
	[playFieldSprite removeAllChildren];
		
	resetButtonVisible = NO;
	
	// reset level and score parameters and update text so the game can start
	// from the beginning		
	level = 1;
	score = 0;
	lives = 2;
	[self updateTextLabels];
		
	// restart the game
	[self drawBalloons];
}


-(void)onContinueButtonTriggered:(SPEvent*)event
{
	[playFieldSprite removeAllChildren];
	balloonIsVisible = NO;

	[self.juggler removeAllObjects];
	[self drawBalloons];
}

-(void)onVideoWallButtonTriggered:(SPEvent*)event
{
	[self.juggler removeAllObjects];
	[playFieldSprite removeAllChildren];
	[delegate buttonClicked];
}

-(void)updateTextLabels
{
	levelTextField.text = [NSString stringWithFormat:@"Level: %d", level];
	scoreTextField.text = [NSString stringWithFormat:@"Score: %d", score];
	livesTextField.text = [NSString stringWithFormat:@"Lives: %d", lives];
}

@end

