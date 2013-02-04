//
//  NSNotificationCenter+Forecast.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "NSNotificationCenter+Forecast.h"

@implementation NSNotificationCenter (Forecast)

+ (void)postSetActiveTabNotificationToDefaultCenterFromSource:(id)source withTabIndex:(NSUInteger)tabIndex shouldPopToRoot:(BOOL)shouldPopToRoot andPushViewControllerForParseClass:(NSString *)parseClassName withObject:(PFObject *)object {
    
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[kNotificationSetActiveTabTabIndexKey] = @(tabIndex);
    userInfo[kNotificationSetActiveTabShouldPopToRootKey] = @(shouldPopToRoot);
    if (parseClassName && object) {
        userInfo[kNotificationSetActiveTabPushViewControllerForParseClassKey] = parseClassName;
        userInfo[kNotificationSetActiveTabPushViewControllerForParseClassObjectKey] = object;
    }
    
    [[self defaultCenter] postNotificationName:kNotificationSetActiveTab object:source userInfo:userInfo];
    
}

@end
