//
//  FCParseManager.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCParseManager : NSObject { }

#pragma mark Lifecycle

+ (FCParseManager *) sharedInstance;

#pragma mark Data Retrieval

- (void) getArtistsInBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all artists in the database at once. Could be dangerous once there are a lot of objects there!
- (void) getProjectsForArtistWithID:(NSString *)artistID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all projects for given artist. If artistID is nil, Gets all projects in the database at once. Could be dangerous once there are a lot of objects there!
- (void) getLocationsForProjectWithID:(NSString *)projectID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all locations for given project. If projectID is nil, gets all locations in the database at once. Could be dangerous once there are a lot of objects there!

#pragma mark Utility

- (void) convertCategoriesColorValuesFromLargeIntegersToPercentages;

@end
