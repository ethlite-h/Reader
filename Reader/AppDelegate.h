//
//  AppDelegate.h
//  Reader
//
//  Created by Helen Ma on 1/11/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class FeedViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
