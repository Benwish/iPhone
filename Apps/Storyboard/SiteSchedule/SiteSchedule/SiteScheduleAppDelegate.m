//
//  ShopAppDelegate.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "SiteScheduleAppDelegate.h"
#import "SiteScheduleParser.h"

@interface SiteScheduleAppDelegate()

@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation SiteScheduleAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize managedObjectModel;
@synthesize storeCoordinator;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    return YES;
}

#pragma mark Core Data Initialisierung

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationSupportURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"SiteSchedule" withExtension:@"mom"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"SiteSchedule.sqlite"];
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:theURL options:nil error:&theError]) {
            self.storeCoordinator = theCoordinator;
        }
        else {
            NSLog(@"storeCoordinator: %@", theError);
        }
    }
    return storeCoordinator;
}

- (NSError *)updateWithInputStream:(NSInputStream *)inStream {
    NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
    NSXMLParser *theParser = [[NSXMLParser alloc] initWithStream:inStream];
    SiteScheduleParser *theDelegate = [[SiteScheduleParser alloc] initWithManagedObjectContext:theContext];
    
    theContext.persistentStoreCoordinator = self.storeCoordinator;
    theParser.delegate = theDelegate;
    theParser.shouldProcessNamespaces = YES;
    theParser.shouldReportNamespacePrefixes = YES;
    [theParser parse];
    return theDelegate.error;
}

@end
