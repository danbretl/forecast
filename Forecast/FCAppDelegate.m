//
//  FCAppDelegate.m
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCAppDelegate.h"
#import "FCParseManager.h"
#import "NSNotificationCenter+Forecast.h"
#import "FCArtistViewController.h"
#import "FCProjectViewController.h"
#import "TabBarConstants.h"

@interface FCAppDelegate()
@property (nonatomic, readonly) UITabBarController * tabBarController;
- (UINavigationController *) navControllerForTabIndex:(int)tabIndex;
@end

@implementation FCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Set up Parse
    [Parse setApplicationId:@"XeOSvRfKmXY8XThsRV8seVc8RhaKMor4TMpxsOKR" clientKey:@"zXJtzymbqSh2OOCt6O74dmd01UcKTQEJk14T3Pv1"];
    // Set up Parse automatic anonymous users
    [PFUser enableAutomaticUser];
    [[FCParseManager sharedInstance] incrementUserSessionCount];
    [[FCParseManager sharedInstance] getFavoritesInBackgroundWithBlock:NULL];
    
    // Parse Admin Utility
    // ...
    // Global notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToSetActiveTabNotification:) name:kNotificationSetActiveTab object:nil];
    
    // UIAppearance Customization
    // Tab Bar
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bar_bg_tile"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"clear"]];
    // Tab Bar Items
    [[self navControllerForTabIndex:kTabBarIndexMap].tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_bar_item_map_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_bar_item_map"]];
    [[self navControllerForTabIndex:kTabBarIndexArtists].tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_bar_item_artists_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_bar_item_artists"]];
    [[self navControllerForTabIndex:kTabBarIndexProjects].tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_bar_item_projects_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_bar_item_projects"]];
    return YES;
    // Navigation Bar
    // Not able to set navigation bar appearance here for some reason... I've had this problem before. Will figure it out later. Doing it in view controllers' viewDidLoad instead for now.
}

- (UITabBarController *) tabBarController {
    return (UITabBarController *)self.window.rootViewController;
}

- (UINavigationController *) navControllerForTabIndex:(int)tabIndex {
    return (UINavigationController *)self.tabBarController.viewControllers[tabIndex];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[FCParseManager sharedInstance] incrementUserSessionCount];
    [[FCParseManager sharedInstance] getFavoritesInBackgroundWithBlock:NULL];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}


#pragma mark - Notifications

- (void) respondToSetActiveTabNotification:(NSNotification *)notification {
    
    NSNumber * tabIndex = notification.userInfo[kNotificationSetActiveTabTabIndexKey];
    BOOL shouldPopToRoot = [notification.userInfo[kNotificationSetActiveTabShouldPopToRootKey] boolValue];
    NSString * pushParseClassName = notification.userInfo[kNotificationSetActiveTabPushViewControllerForParseClassKey];
    PFObject * pushParseObject = notification.userInfo[kNotificationSetActiveTabPushViewControllerForParseClassObjectKey];
    
    UITabBarController * tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController * navController = tabBarController.viewControllers[tabIndex.integerValue];
    tabBarController.selectedViewController = navController;
    if (shouldPopToRoot) {
        [navController popToRootViewControllerAnimated:NO];
        UIViewController * viewController = navController.viewControllers[0];
        if ([viewController respondsToSelector:@selector(tableView)]) {
            UITableView * tableView = (UITableView *)[viewController performSelector:@selector(tableView)];
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:NO];
            if ([viewController respondsToSelector:@selector(objects)] &&
                pushParseObject != nil) {
                NSArray * objects = [viewController performSelector:@selector(objects)];
                NSUInteger indexOfObject = [objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    PFObject * objectToTest = (PFObject *)obj;
                    return [objectToTest.objectId isEqualToString:pushParseObject.objectId];
                }];
                if (indexOfObject != NSNotFound &&
                    indexOfObject < objects.count) {
                    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfObject inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                }
            }
        }
    }
    if (pushParseClassName != nil && pushParseObject != nil) {
        UIViewController * viewController = nil;
        if ([pushParseClassName isEqualToString:kParseClassArtist]) {
            FCArtistViewController * artistViewController = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FCArtistViewController"];
            artistViewController.artist = pushParseObject;
            viewController = artistViewController;
        } else if ([pushParseClassName isEqualToString:kParseClassProject]) {
            FCProjectViewController * projectViewController = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"FCProjectViewController"];
            projectViewController.project = pushParseObject;
            viewController = projectViewController;
        }
        if (viewController) [navController pushViewController:viewController animated:NO];
    }
}

#pragma mark - NSManagedObjectContext

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Forecast" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Forecast.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
