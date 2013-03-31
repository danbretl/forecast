//
//  FCFavoritesController.h
//  Forecast
//
//  Created by Dan Bretl on 3/31/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FCFavoritesControllerDelegate;

@interface FCFavoritesController : NSObject

- (id) initWithDelegate:(id<FCFavoritesControllerDelegate>)delegate;

@property (nonatomic, weak) id<FCFavoritesControllerDelegate> delegate;

- (void) setFavorite:(BOOL)makeFavorite; // Will call delegate for object class and object ID

@end

@protocol FCFavoritesControllerDelegate <NSObject>
@required
- (NSString *) objectClassForFavoritesController:(FCFavoritesController *)favoritesController;
- (NSString *) objectIDForFavoritesController:(FCFavoritesController *)favoritesController;
@optional
- (void) favoritesController:(FCFavoritesController *)favoritesController willMakeObjectOfClass:(NSString *)objectClass withObjectID:(NSString *)objectID favorite:(BOOL)makeFavorite;
- (void) favoritesController:(FCFavoritesController *)favoritesController didMakeObjectOfClass:(NSString *)objectClass withObjectID:(NSString *)objectID favorite:(BOOL)makeFavorite error:(NSError *)error;
@end