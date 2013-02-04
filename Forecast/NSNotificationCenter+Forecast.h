//
//  NSNotificationCenter+Forecast.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationSetActiveTab @"kNotificationSetActiveTab"
#define kNotificationSetActiveTabTabIndexKey @"kNotificationSetActiveTabTabIndexKey"
#define kNotificationSetActiveTabShouldPopToRootKey @"kNotificationSetActiveTabShouldPopToRootKey"
#define kNotificationSetActiveTabPushViewControllerForParseClassKey @"kNotificationSetActiveTabPushViewControllerForParseClassKey"
#define kNotificationSetActiveTabPushViewControllerForParseClassObjectKey @"kNotificationSetActiveTabPushViewControllerForParseClassObjectIDKey"

@interface NSNotificationCenter (Forecast)

+ (void)postSetActiveTabNotificationToDefaultCenterFromSource:(id)source withTabIndex:(NSUInteger)tabIndex shouldPopToRoot:(BOOL)shouldPopToRoot andPushViewControllerForParseClass:(NSString *)parseClassName withObject:(PFObject *)object;

@end
