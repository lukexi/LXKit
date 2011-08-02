//
//  LXCoreDataOperation.m
//  LXKit
//
//  Created by Luke Iannini on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LXCoreDataOperation.h"

@interface LXCoreDataOperation ()

@property (nonatomic, retain, readwrite) NSManagedObjectContext *insertionContext;

@end

@implementation LXCoreDataOperation
@synthesize insertionContext, insertionBlock, mainContext;


- (void)dealloc 
{
    [insertionContext release];
    [mainContext release];
    [insertionBlock release];
    [super dealloc];
}

+ (id)operationWithMainContext:(NSManagedObjectContext *)mainContext
                         block:(LXCoreDataBlock)insertionBlock;
{
    LXCoreDataOperation *operation = [[[self alloc] init] autorelease];
    operation.mainContext = mainContext;
    operation.insertionBlock = insertionBlock;
    return operation;
}

- (void)main
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(insertionContextDidSave:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:self.insertionContext];
    
    [self performOperation];
    if (self.insertionBlock) 
    {
        self.insertionBlock(self.insertionContext);
    }
    
    NSError *error = nil;
    BOOL success = [self.insertionContext save:&error];
    if (!success) 
    {
        NSLog(@"Error saving insert operation: %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSManagedObjectContextDidSaveNotification 
                                                  object:insertionContext];
}

- (void)performOperation
{
    // To override in subclass
}

- (void)insertionContextDidSave:(NSNotification *)notification
{
    dispatch_sync(dispatch_get_main_queue(), ^(void) {
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

- (NSManagedObjectContext *)insertionContext
{
    if (!insertionContext) 
    {
        insertionContext = [[NSManagedObjectContext alloc] init];
        [insertionContext setPersistentStoreCoordinator:[self.mainContext persistentStoreCoordinator]];
    }
    return insertionContext;
}

@end