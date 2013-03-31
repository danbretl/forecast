//
//  FCParseManager.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kParseClassArtist @"Artist"
#define kParseClassProject @"Project"

#define kLinkTypePhoneNumber @"phone"
#define kLinkTypeWebsite @"web"

typedef void (^PFFavoriteResultBlock)(PFObject * favorite, NSError * error);

@interface FCParseManager : NSObject { }

#pragma mark Lifecycle

+ (FCParseManager *) sharedInstance;

#pragma mark Data Retrieval

- (void) getCategoriesInBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all categories in the database at once.
- (void) getArtistsInBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all artists in the database at once. Could be dangerous once there are a lot of objects there!
- (void) getProjectsForArtistWithID:(NSString *)artistID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all projects for given artist. If artistID is nil, Gets all projects in the database at once. Could be dangerous once there are a lot of objects there!
- (void) getSearchResultsForTerm:(NSString *)searchTerm includeProjects:(BOOL)searchProjects andArtists:(BOOL)searchArtists inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all artists and/or projects that match the given search term.
- (void) getLocationsForProjectWithID:(NSString *)projectID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all locations for given project. If projectID is nil, gets all locations in the database at once. Could be dangerous once there are a lot of objects there!
- (void) getFirstImageForObjectOfClass:(NSString *)objectClass withID:(NSString *)objectID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets the first big image for given artist or project. If objectClass or objectID is nil, this method does nothing.
- (void) getLinksForObjectOfClass:(NSString *)objectClass withID:(NSString *)objectID inBackgroundWithBlock:(PFArrayResultBlock)block; // Gets all links for given artist or project. If objectClass or objectID is nil, this method does nothing.

#pragma mark Users & Favorites

- (void) incrementUserSessionCount;
- (void) setFavorite:(BOOL)isFavorite objectOfClass:(NSString *)objectClass withID:(NSString *)objectID inBackgroundWithBlock:(PFFavoriteResultBlock)block; // Sets (or unsets) a user favorite artist or project. Returns the Favorite object (not the Favorited object) or an error.
- (void) getFavoritesInBackgroundWithBlock:(PFArrayResultBlock)block; // Gets favorites for current user (including the related artists/projects). If there is no current user, this method does nothing. Favorites are always stored by (and can be checked using) the parse manager, so it is no problem (and somewhat expected) for block to be NULL.
- (BOOL) isFavoriteObjectWithClass:(NSString *)objectClass withID:(NSString *)objectID forceServerCheckInBackgroundWithBlock:(PFFavoriteResultBlock)block; // Checks local data to see if object of given class and ID is a favorite for current user. This local value is returned immediately. If block is not NULL, then also checks server for up-to-date value. If there is no current user, or if objectClass or objectID is nil, this method does nothing, and returns NO.

#pragma mark External Links

- (void) respondToLinkSelection:(PFObject *)link; // link should include its type

#pragma mark Utility

- (void) convertCategoriesColorValuesFromLargeIntegersToPercentages;

@end
