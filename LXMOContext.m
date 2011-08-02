//
//  LXMOContext.m
//  LXKit
//
//  Created by Luke Iannini on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LXMOContext.h"

@interface LXMOContext ()

@property (nonatomic, retain, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSPersistentStore *)addPersistentStoreOrError:(NSError **)error;

- (NSString *)applicationDocumentsDirectory;
- (NSURL *)storeURL;

+ (LXMOContext *)sharedInstance;

@end

@implementation LXMOContext
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize name;

static LXMOContext *sharedLXMOContext = nil;

+ (void)setSharedContextName:(NSString *)name
{
    [self sharedInstance].name = name;
    
}

+ (LXMOContext *)sharedInstance
{
    if (!sharedLXMOContext)
    {
        sharedLXMOContext = [[self alloc] init];
    }
    return sharedLXMOContext;
}

+ (NSManagedObjectContext *)mainContext
{
    NSAssert([self sharedInstance].name, @"Must setSharedContextName: of LXMOContext before calling +mainContext");
    return [self sharedInstance].managedObjectContext;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
        [managedObjectContext setUndoManager:nil];
        [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:self.name ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![self addPersistentStoreOrError:&error])
    {
        NSLog(@"Error while setting up Persistent Store %@, %@", error, [error userInfo]);
        NSLog(@"Probably just a schema change, deleting local data and trying again: %@", [self storeURL]);
        
        [[NSFileManager defaultManager] removeItemAtPath:[[self storeURL] path] error:&error];
        
        if (![self addPersistentStoreOrError:&error])
        {
            NSString *message = [NSString stringWithFormat:@"Sorry, an error has occurred: %@.  Please restart %@, and if that doesn't work, try deleting and redownloading it.", self.name, [error localizedDescription]];
            [[[[UIAlertView alloc] initWithTitle:@"Couldn't Create Store"
                                         message:message
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] autorelease] show];
            NSLog(@"Unresolved error while setting up Persistent Store %@, %@", error, [error userInfo]);
        }
    }
    
    return persistentStoreCoordinator;
}

- (NSPersistentStore *)addPersistentStoreOrError:(NSError **)error
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    return [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:[self storeURL]
                                                          options:options
                                                            error:error];
}

- (NSURL *)storeURL
{
    NSParameterAssert(self.name);
    return [NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                                   stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.name]]];
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
