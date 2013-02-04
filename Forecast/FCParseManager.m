//
//  FCParseManager.m
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCParseManager.h"

@implementation FCParseManager { }

#pragma mark Lifecycle

+ (FCParseManager *)sharedInstance {
    static FCParseManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FCParseManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark Data Retrieval

- (void)getArtistsInBackgroundWithBlock:(PFArrayResultBlock)block {
    PFQuery * query = [PFQuery queryWithClassName:@"Artist"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:block];
}

- (void)getProjectsForArtistWithID:(NSString *)artistID inBackgroundWithBlock:(PFArrayResultBlock)block {
    PFQuery * query = [PFQuery queryWithClassName:@"Project"];
    [query orderByAscending:@"title"];
    if (artistID) {
        [query whereKey:@"artist" equalTo:[PFObject objectWithoutDataWithClassName:@"Artist" objectId:artistID]];
    }
    [query includeKey:@"category"];
    [query includeKey:@"artist"];
    [query findObjectsInBackgroundWithBlock:block];
}
- (void)getLocationsForProjectWithID:(NSString *)projectID inBackgroundWithBlock:(PFArrayResultBlock)block {
    PFQuery * query = [PFQuery queryWithClassName:@"Location"];
    if (projectID) {
        [query whereKey:@"project" equalTo:[PFObject objectWithoutDataWithClassName:@"Project" objectId:projectID]];
    }
    [query includeKey:@"project"];
    [query includeKey:@"project.artist"];
    [query includeKey:@"project.category"];
    [query findObjectsInBackgroundWithBlock:block];
}

- (void)getFirstImageForObjectOfClass:(NSString *)objectClass withID:(NSString *)objectID inBackgroundWithBlock:(PFArrayResultBlock)block {
    if (objectClass && objectID) {
        PFQuery * query = [PFQuery queryWithClassName:@"Image"];
        [query orderByAscending:@"order"];
        query.limit = 1;
        [query whereKey:objectClass.lowercaseString equalTo:[PFObject objectWithoutDataWithClassName:objectClass objectId:objectID]];
        [query findObjectsInBackgroundWithBlock:block];
    }
}

- (void)getLinksForObjectOfClass:(NSString *)objectClass withID:(NSString *)objectID inBackgroundWithBlock:(PFArrayResultBlock)block {
    if (objectClass && objectID) {
        PFQuery * query = [PFQuery queryWithClassName:@"Link"];
        [query orderByAscending:@"order"];
        [query whereKey:objectClass.lowercaseString equalTo:[PFObject objectWithoutDataWithClassName:objectClass objectId:objectID]];
        [query includeKey:@"type"];
        [query findObjectsInBackgroundWithBlock:block];
    }
}

#pragma mark External Links

- (void) respondToLinkSelection:(PFObject *)link {
    if ([link[@"type"][@"name"] isEqualToString:kLinkTypePhoneNumber]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", link[@"destination"]]]];
    } else if ([link[@"type"][@"name"] isEqualToString:kLinkTypeWebsite]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link[@"destination"]]];
    }
}

#pragma mark Utility

- (void)convertCategoriesColorValuesFromLargeIntegersToPercentages {
    PFQuery * categoriesQuery = [PFQuery queryWithClassName:@"Category"];
    [categoriesQuery orderByAscending:@"colorRed"];
    [categoriesQuery addAscendingOrder:@"colorGreen"];
    [categoriesQuery addAscendingOrder:@"colorBlue"];
    NSLog(@"Getting categories");
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BOOL cancel = YES;
        // Quick check of values - assumes that at least one value of one color component should probably be above 1
        NSLog(@"Checking existing values");
        for (PFObject * category in objects) {
            cancel = !([category[@"colorRed"] intValue] > 1 ||
                       [category[@"colorGreen"] intValue] > 1 ||
                       [category[@"colorBlue"] intValue] > 1);
            if (!cancel) break;
        }
        if (!cancel) {
            NSLog(@"Converting values");
            for (PFObject * category in objects) {
                NSLog(@"  %@", category[@"name"]);
                NSLog(@"    Current values = R:%d G:%d B:%d", [category[@"colorRed"] intValue], [category[@"colorGreen"] intValue], [category[@"colorBlue"] intValue]);
                category[@"colorRed"] = @([category[@"colorRed"] doubleValue] / 255.0);
                category[@"colorGreen"] = @([category[@"colorGreen"] doubleValue] / 255.0);
                category[@"colorBlue"] = @([category[@"colorBlue"] doubleValue] / 255.0);
                NSLog(@"    Converted values = R:%f G:%f B:%f", [category[@"colorRed"] doubleValue], [category[@"colorGreen"] doubleValue], [category[@"colorBlue"] doubleValue]);
                NSLog(@"  Saving converted values");
                [category saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"  Save %@", succeeded ? @"successful" : @"failure");
                }];
            }
        } else {
            NSLog(@"All existing values appear to be <=1, cancelling without conversion.");
        }
    }];
}

@end
