//
//  SelectableMediaGameAppDelegate.m
//  SelectableMediaGame
//
//  Copyright 2012 Selectable Media. All rights reserved.
//

#import "SelectableMediaGameViewController.h"

#import "Game.h"

#import "SBJSON.h"

@implementation SelectableMediaGameViewController

@synthesize spView;

// Request to our internal "Game" API to reset lives, in other words to always starting in 2
-(void)resetLives {
	NSString *url = [NSString stringWithFormat:@"http://dl.selectablemedia.com/reset?uid=%@", [[UIDevice currentDevice] uniqueIdentifier]];	
	NSURL *baseURL = [[NSURL URLWithString:url] retain];
	[NSURLRequest requestWithURL:baseURL];
}

// Request to our internal "Game" API to get how many lives are available for this user
-(void)requestLives {
	NSString *url = [NSString stringWithFormat:@"http://dl.selectablemedia.com/lives?uid=%@", [[UIDevice currentDevice] uniqueIdentifier]];
	
	NSURL *baseURL = [[NSURL URLWithString:url] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *jsonResult = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSDictionary *dictionary = [jsonResult JSONValue];
	
	int jsonLives = [[[dictionary objectForKey:@"lives"] stringValue] intValue];
	if (jsonLives <= 0) {
		jsonLives = 2;
	}
	lives = jsonLives;
	
	[self startGame];
}

// Hiding "MORE LIVES" button in case user already watched all videos for today.
-(void)videosForUser {
    // Call To Action - to make sure we have videos available
	NSString *url = [NSString stringWithFormat:@"http://ads.sele.co/v1/videos_for/%@/on/iPhone_Developer_5139_5053.json",
					 [[UIDevice currentDevice] uniqueIdentifier]];

	NSURL *baseURL = [[NSURL URLWithString:url] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];

	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *jsonResult = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSDictionary *dictionary = [jsonResult JSONValue];

	if ([[dictionary objectForKey:@"videos"] boolValue])
		videosAvailable = TRUE;
}

-(void)buttonClicked {
	[self stopGame];
    [symbiont presentModalAdSelectorWithParentController:self animated:YES];
}

- (void)videoWallClosed:(BOOL) allComplete {
	[videoWall removeFromSuperview];
	if (allComplete)
		videosAvailable = FALSE;
	[self requestLives];
}

- (void)smSymbiontDidCloseAdSelectorView:(SmSymbiont *)symbiont {
	[self requestLives];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	lives = score = level = -1;
	[self resetLives];
	[self videosForUser];
	[self requestLives];

    NSString *url = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] uniqueIdentifier]];
	symbiont = [[SmSymbiont symbiontWithUser:url placement:@"iPhone_Developer" publisherSuffix:@"iosexample"] retain];
	symbiont.delegate = self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	[SPPoint purgePool];
    [SPRectangle purgePool];
    [SPMatrix purgePool];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[self stopGame];
    [symbiont release];
}

-(void)startGame {
	self.spView = [[SPView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[self.view addSubview:spView];

	SP_CREATE_POOL(pool);

	Game *game = nil;
	if (lives != -1) {
		game = [[Game alloc] initWithWidthAndValues:320 height:480 lives:lives score:score level:level showButton:videosAvailable];
	} else {
		game = [[Game alloc] initWithWidthAndButton:320 height:480 showButton:videosAvailable];
	}
	
	spView.stage = game;
	[spView start];
	game.delegate = self;
	[game release];
	[SPAudioEngine start];

	SP_RELEASE_POOL(pool);
}

-(void)stopGame {
	Game *game = (Game *)self.spView.stage;
	lives = game.lives;
	score = game.score;
	level = game.level;
	
	[SPAudioEngine stop];
	[spView removeFromSuperview];
	//[self.spView dealloc];
}

@end
