//
//  DataModel.h
//  CardsOnGo
//
//  Created by Grig Uskov on 5/17/13.
//  Copyright (c) 2013 ALSEDI Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define dataModel [DataModel getInstance]

@interface DataModel : NSObject {
    
@protected
    NSManagedObjectContext * managedObjectContext;
    NSManagedObjectModel * managedObjectModel;
    NSPersistentStoreCoordinator * persistentStoreCoordinator;
}

+ (NSURL *)URLForDocumentsFolder;
+ (void)save;
+ (DataModel *)getInstance;

+ (void)deleteObject:(NSManagedObject *)object;
+ (NSManagedObject *)createObjectOfClass:(Class)objClass;

+ (NSArray *)allInstances:(Class)objClass;
+ (NSArray *)allInstances:(Class)objClass withPredicate:(id)stringOrPredicate,...;

@end

