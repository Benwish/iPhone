#import "AlarmClockAppDelegate.h"
#import "AlarmClockViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AlarmClockAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize soundId;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)playSound {
    if(self.soundId == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"ringtone" withExtension:@"caf"];
        SystemSoundID theId;
        
        if(AudioServicesCreateSystemSoundID((CFURLRef) theURL, &theId) == kAudioServicesNoError) {
            self.soundId = [NSNumber numberWithUnsignedInt:theId];
        }
    }
    if(self.soundId) {
        AudioServicesPlaySystemSound([self.soundId unsignedIntValue]);
    }
}

- (void)application:(UIApplication *)inApplication didReceiveLocalNotification:(UILocalNotification *)inNotification {
    if(inApplication.applicationState == UIApplicationStateActive) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:nil 
                                                           message:inNotification.alertBody 
                                                          delegate:nil 
                                                 cancelButtonTitle:NSLocalizedString(@"OK", @"Dismiss alert")
                                                 otherButtonTitles:nil];
        
        [theAlert show];
        [theAlert release];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    if(self.soundId > 0) {
        AudioServicesDisposeSystemSoundID([self.soundId unsignedIntValue]);
        self.soundId = nil;
    }
    [viewController release];
    [window release];
    [super dealloc];
}


@end
