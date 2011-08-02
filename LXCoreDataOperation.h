//
//  LXCoreDataOperation.h
//  LXKit
//
//  Created by Luke Iannini on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LXCoreDataBlock)(NSManagedObjectContext *operationContext);

@interface LXCoreDataOperation : NSOperation

+ (id)operationWithMainContext:(NSManagedObjectContext *)mainContext
                         block:(LXCoreDataBlock)insertionBlock;

- (void)performOperation;
@property (nonatomic, retain) NSManagedObjectContext *mainContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *insertionContext;
@property (nonatomic, copy) LXCoreDataBlock insertionBlock;

@end
