#import "AlarmClockAppDelegate.h"
#import "AlarmClockViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AlarmClockAppDelegate()

@end

@implementation AlarmClockAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize soundId;

#pragma mark -
#pragma mark Application lifecycle

- (void)dealloc {
    self.soundId = nil;    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSNumber *)soundId {
    if(soundId == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"ringtone" withExtension:@"caf"];
        SystemSoundID theId;
        
        if(AudioServicesCreateSystemSoundID((__bridge CFURLRef) theURL, &theId) == kAudioServicesNoError) {
            self.soundId = [NSNumber numberWithUnsignedInt:theId];
        }
    }
    return soundId;
}

- (void)setSoundId:(NSNumber *)inSoundId {
    if(soundId != inSoundId) {
        if(soundId != nil) {
            AudioServicesDisposeSystemSoundID([soundId unsignedIntValue]);
        }
        soundId = inSoundId;
    }
}

- (void)playSound {
    NSNumber *theId = self.soundId;
    
    if(theId) {
        AudioServicesPlaySystemSound([theId unsignedIntValue]);
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
        [self playSound];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    self.soundId = nil;    
}

@end
