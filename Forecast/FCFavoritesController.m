//
//  FCFavoritesController.m
//  Forecast
//
//  Created by Dan Bretl on 3/31/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCFavoritesController.h"

@implementation FCFavoritesController

- (id)initWithDelegate:(id<FCFavoritesControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setFavorite:(BOOL)makeFavorite {
    NSString * objectClass = [self.delegate objectClassForFavoritesController:self];
    NSString * objectID = [self.delegate objectIDForFavoritesController:self];
    if (objectClass && objectID) {
        if ([self.delegate respondsToSelector:@selector(favoritesController:willMakeObjectOfClass:withObjectID:favorite:)]) {
            [self.delegate favoritesController:self willMakeObjectOfClass:objectClass withObjectID:objectID favorite:makeFavorite];
        }
        [[FCParseManager sharedInstance] setFavorite:makeFavorite objectOfClass:objectClass withID:objectID inBackgroundWithBlock:^(PFObject *favorite, NSError *error) {
            NSLog(@"[FCParseManager sharedInstance] setFavorite... favorite : %@", favorite);
            NSLog(@"[FCParseManager sharedInstance] setFavorite... error    : %@", error);
            if ([self.delegate respondsToSelector:@selector(favoritesController:didMakeObjectOfClass:withObjectID:favorite:error:)]) {
                [self.delegate favoritesController:self didMakeObjectOfClass:objectClass withObjectID:objectID favorite:[favorite[@"isFavorite"] boolValue] error:error];
            }
        }];
    }
}

@end
