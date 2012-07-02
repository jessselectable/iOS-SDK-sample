Selectable Media iOS SDK
========================

Integration Procedure
---------------------


1) Import the Selectable Media iOS SDK to your project.

Copy the library, headers, and resources in this SDK folder into your project. You can do this by dragging the files from finder into the Xcode project manager.

Make sure the `MediaPlayer.framework` is included in our project.
Make sure the `QuartzCore.framework` is included in our project.
Make sure the `Twitter.framework` is included in our project.

2) Implement SmSymbiontDelegate

The controller that will display the Ad Selector must implement SmSymbiontDelegate. First import "SelectableMedia.h" in controller header:
	#import "SelectableMedia.h"
	
Add SmSymbiontDelegate to protocol list:
	@interface ViewController : UIViewController <SmSymbiontDelegate> 
		
Implement required method:
	- (void)smSymbiontDidCloseAdSelectorView:(SmSymbiont *)symbiont;
which is called when the add selector closes.


3) Create SmSymbiont

Add a member to the controller that will display the Ad Selector of type SmSymbiont, initialize it in the controller's designated initializer, and release it in the controller's dealloc method.

For example, add this member to the controller:
	SmSymbiont *symbiont;

And initialize it in the designated initializer (usually `initWithNidName:bundle:`):
	symbiont = [[SmSymbiont symbiontWithUser:userId placement:@"iOS_Developer" publisherSuffix:@"iosexample"] retain];
	symbiont.delegate = self;

Don't forget to release the symbiont instance in dealloc:
	[symbiont release];

  
4) Display the Ad Selector

When the user presses the call to action, display the ad selector:
	[symbiont presentModalAdSelectorWithParentController:self animated:YES];
    
5) Update YOURAPP-Info.plist
    Add "URL Types", then select Item 0, then add "URL Schemes" then set Item 0 to "fb183027671727997iosexample"

6) Add application:openURL:sourceApplication:annotation:
    BOOL wasHandled = [symbiont openURL:sourceApplication:annotation:];
    if (!wasHandled) {
        // handle non selectable media URL
    }
