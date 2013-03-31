//
//  FCViewController.h
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//
//  This class is a superclass of basically all view controllers in the project. It allows us to reliably customize the appearance of navigation bars throughout the app. This should really be done once in the app delegate, but that hasn't been working so far. That is most certainly due to human error, but this human doesn't have time to figure it out just now, and this temporary solution does not really have any serious drawbacks (nor would it be hard to undo later when the proper solution is successfully implemented).
//  This class also contains functionality for showing / hiding search.

#import <UIKit/UIKit.h>
#import "FCSearchViewController.h"
#import "FCFavoritesController.h"
#import "FCParseManager.h"

typedef enum {
    UIBarButtonItemSideLeft  = 1,
    UIBarButtonItemSideRight = 2,
} UIBarButtonItemSide;

typedef enum {
    UIBarButtonItemSpecialNone = 0,
    UIBarButtonItemSpecialSearch = 1,
    UIBarButtonItemSpecialStar = 2,
} UIBarButtonItemSpecial;

@interface FCViewController : UIViewController<FCFavoritesControllerDelegate, FCSearchViewControllerDelegate>

- (UIBarButtonItem *) setBackBarButtonItemToArrowButton;
- (void) clearLeftBarButtonItem;

- (UIBarButtonItem *) setRightBarButtonItemToSearchButton;
- (UIBarButtonItem *) setRightBarButtonItemToStarButton;
- (void) clearRightBarButtonItem;

- (void) setBarButtonItemOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected;

- (void) barButtonItemTouchedUpOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected; // Subclasses should override this method

@property (nonatomic, weak) IBOutlet UIView * searchContainerView;
@property (nonatomic) CGFloat searchContainerViewVisibleAlpha;
@property (nonatomic) CGFloat searchContainerViewHiddenAlpha;
@property (nonatomic) CGFloat searchContainerViewVisibleOriginY;
@property (nonatomic) CGFloat searchContainerViewHiddenOriginY;
@property (nonatomic, weak, readonly) FCSearchViewController * searchViewController;
@property (nonatomic) BOOL isSearchVisible; // Not animated
- (void) setIsSearchVisible:(BOOL)shouldBeVisible animated:(BOOL)animated;

@property (nonatomic) FCFavoritesController * favoritesController;

@end
