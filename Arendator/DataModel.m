//
//  DataModel.m
//  CardsOnGo
//
//  Created by Grig Uskov on 5/17/13.
//  Copyright (c) 2013 ALSEDI Group. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel


+ (void)initialize {
    [DataModel getInstance];
}


static DataModel *_instance = nil;
- (id)init {
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSError * __autoreleasing error = nil;
        NSURL *storeURL = [[DataModel URLForDocumentsFolder] URLByAppendingPathComponent:@"DataModel"];
        
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        if (!store) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            NSLog(@"%@", [error localizedDescription]);
            abort();
        }
        
        if (persistentStoreCoordinator) {
            managedObjectContext = [[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
    return self;
}


+ (NSURL *)URLForDocumentsFolder {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


+ (DataModel *)getInstance {
    if (!_instance)
        _instance = [[DataModel alloc] init];
    return _instance;
}


+ (void)save {
    NSError * error = nil;
    NSManagedObjectContext *managedObjectContext = [DataModel getInstance]->managedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			NSLog(@"%@", [error localizedDescription]);
            abort();
        }
    }
}


+ (void)deleteObject:(NSManagedObject *)object {
    [[DataModel getInstance]->managedObjectContext deleteObject:object];
}


+ (NSManagedObject *)createObjectOfClass:(Class)objClass {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(objClass) inManagedObjectContext:[DataModel getInstance]->managedObjectContext];
}


+ (NSArray *)allInstances:(Class)objClass withPredicate:(id)stringOrPredicate, ... {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass(objClass) inManagedObjectContext:[DataModel getInstance]->managedObjectContext]];
    [request setIncludesPropertyValues:YES];
    
    if (stringOrPredicate) {
        NSPredicate *predicate = nil;
        if ([stringOrPredicate isKindOfClass:[NSString class]]) {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                               arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
            predicate = (NSPredicate *)stringOrPredicate;
        [request setPredicate:predicate];
    }
    
    NSError * error = nil;
    NSArray *results = [[DataModel getInstance]->managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
        [NSException raise:NSGenericException format:@"%@", [error description]];
    
    return results;
}


+ (NSArray *)allInstances:(Class)objClass {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass(objClass) inManagedObjectContext:[DataModel getInstance]->managedObjectContext]];
    [request setReturnsObjectsAsFaults:NO]; // На время дебага из релиза убрать
    [request setIncludesPropertyValues:YES]; // с NO на телефоне просто валится с NSArray IndexOutOfBounds:0
    return [[DataModel getInstance]->managedObjectContext executeFetchRequest:request error:nil];
}


@end
