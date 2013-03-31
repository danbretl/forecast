//
//  FCViewController.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCViewController.h"

@interface FCViewController ()
- (UIBarButtonItem *)setBarButtonItemOnSide:(UIBarButtonItemSide)side isBackButton:(BOOL)isBackButton selectedOnTouchDown:(BOOL)shouldSelectOnTouchDown toCustomButtonWithImageNormal:(NSString *)imageNormal isImageNormalLight:(BOOL)isImageNormalLight imageHighlighted:(NSString *)imageHighlighted isImageHighlightedLight:(BOOL)isImageHighlightedLight;
- (void) clearBarButtonItemOnSide:(UIBarButtonItemSide)side;
- (void) barButtonItemTouchedDownForSelection:(UIButton *)button;
- (void) barButtonItemDraggedOutForSelection:(UIButton *)button;
- (void) barButtonItemDraggedInForSelection:(UIButton *)button;
- (void) barButtonItemTouchedUpOutsideForSelection:(UIButton *)button;
- (void) backBarButtonItemTouchedUp;
- (void) leftBarButtonItemTouchedUp:(UIButton *)button;
- (void) rightBarButtonItemTouchedUp:(UIButton *)button;
@property (nonatomic) UIBarButtonItemSpecial leftBarButtonItemSpecial;
@property (nonatomic) UIBarButtonItemSpecial rightBarButtonItemSpecial;
@end

@implementation FCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Customize appearance
    // Navigation Bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_str"] forBarMetrics:UIBarMetricsDefault];
    // Search Container View
    self.searchContainerViewVisibleAlpha = 0.75;
    self.searchContainerViewHiddenAlpha = 0.0;
    self.searchContainerViewVisibleOriginY = 0;
    self.searchContainerViewHiddenOriginY = self.searchContainerViewVisibleOriginY - self.searchContainerView.frame.size.height;
    [self showSearchViews:self.isSearchVisible animated:NO];
}

- (UIBarButtonItem *)setBackBarButtonItemToArrowButton {
    self.leftBarButtonItemSpecial = UIBarButtonItemSpecialNone;
    return [self setBarButtonItemOnSide:UIBarButtonItemSideLeft isBackButton:YES selectedOnTouchDown:NO toCustomButtonWithImageNormal:@"nav_bar_back_light" isImageNormalLight:YES imageHighlighted:@"nav_bar_back_dark" isImageHighlightedLight:NO];
}

- (UIBarButtonItem *)setRightBarButtonItemToSearchButton {
    self.rightBarButtonItemSpecial = UIBarButtonItemSpecialSearch;
    return [self setBarButtonItemOnSide:UIBarButtonItemSideRight isBackButton:NO selectedOnTouchDown:NO toCustomButtonWithImageNormal:@"nav_bar_glass_light" isImageNormalLight:YES imageHighlighted:@"nav_bar_glass_dark" isImageHighlightedLight:NO];
}

- (UIBarButtonItem *)setRightBarButtonItemToStarButton {
    self.rightBarButtonItemSpecial = UIBarButtonItemSpecialStar;
    UIBarButtonItem * barButtonItem = [self setBarButtonItemOnSide:UIBarButtonItemSideRight isBackButton:NO selectedOnTouchDown:YES toCustomButtonWithImageNormal:@"nav_bar_star_light" isImageNormalLight:YES imageHighlighted:@"nav_bar_star_light_filled" isImageHighlightedLight:YES];
    return barButtonItem;
}

- (UIBarButtonItem *)setBarButtonItemOnSide:(UIBarButtonItemSide)side isBackButton:(BOOL)isBackButton selectedOnTouchDown:(BOOL)shouldSelectOnTouchDown toCustomButtonWithImageNormal:(NSString *)imageNormal isImageNormalLight:(BOOL)isImageNormalLight imageHighlighted:(NSString *)imageHighlighted isImageHighlightedLight:(BOOL)isImageHighlightedLight {
    
    // Make button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // For a regular button:
    // Normal = imageNormal
    // Highlighted = imageHighlighted
    // Selected = imageHighlighted
    // Selected+Highlighted = imageNormal
    
    // For a button that should select on touch down:
    // Normal = imageNormal
    // Highlighted = imageNormal
    // Selected = imageHighlighted
    // Selected+Highlighted = imageHighlighted
    
    NSString * imageSelected = imageHighlighted;
    NSString * imageSelectedHighlighted = imageNormal;
    BOOL isImageSelectedLight = isImageHighlightedLight;
    BOOL isImageSelectedHighlightedLight = isImageNormalLight;
    
    if (shouldSelectOnTouchDown) {
        imageSelectedHighlighted = imageHighlighted;
        imageHighlighted = imageNormal;
        isImageSelectedHighlightedLight = isImageHighlightedLight;
        isImageHighlightedLight = isImageNormalLight;
    }
    
    void(^setButtonState)(UIButton *, NSString *, BOOL, UIControlState) = ^(UIButton * button, NSString * imageName, BOOL isForegroundImageLight, UIControlState controlState){
        [button setImage:[UIImage imageNamed:imageName] forState:controlState];
        [button setBackgroundImage:[[UIImage imageNamed:isForegroundImageLight ? @"clear" : @"white"] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:controlState];
    };
    
    // Normal
    setButtonState(button, imageNormal, isImageNormalLight, UIControlStateNormal);
    // Highlighted
    setButtonState(button, imageHighlighted, isImageHighlightedLight, UIControlStateHighlighted);
    // Selected
    setButtonState(button, imageSelected, isImageSelectedLight, UIControlStateSelected);
    // Selected+Highlighted
    setButtonState(button, imageSelectedHighlighted, isImageSelectedHighlightedLight, UIControlStateSelected|UIControlStateHighlighted);
    button.frame = CGRectMake(0, 0, 40.0, 40.0);
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    SEL selectorUp = @selector(backBarButtonItemTouchedUp);
    if (side == UIBarButtonItemSideLeft) {
        self.navigationItem.leftBarButtonItem = barButton;
        if (!isBackButton) selectorUp = @selector(leftBarButtonItemTouchedUp:);
    } else if (side == UIBarButtonItemSideRight) {
        self.navigationItem.rightBarButtonItem = barButton;
        if (!isBackButton) selectorUp = @selector(rightBarButtonItemTouchedUp:);
    }
    [button addTarget:self action:selectorUp forControlEvents:UIControlEventTouchUpInside];
    if (shouldSelectOnTouchDown) {
        [button addTarget:self action:@selector(barButtonItemTouchedDownForSelection:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(barButtonItemTouchedUpOutsideForSelection:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(barButtonItemDraggedOutForSelection:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(barButtonItemDraggedInForSelection:) forControlEvents:UIControlEventTouchDragEnter];
    }
    
    return barButton;
    
}

- (void)clearLeftBarButtonItem {
    [self clearBarButtonItemOnSide:UIBarButtonItemSideLeft];
}

- (void)clearRightBarButtonItem {
    [self clearBarButtonItemOnSide:UIBarButtonItemSideRight];
}

- (void)clearBarButtonItemOnSide:(UIBarButtonItemSide)side {
    if (side == UIBarButtonItemSideLeft) {
        self.navigationItem.leftBarButtonItem = nil;
        self.leftBarButtonItemSpecial = UIBarButtonItemSpecialNone;
    } else if (side == UIBarButtonItemSideRight) {
        self.navigationItem.rightBarButtonItem = nil;
        self.rightBarButtonItemSpecial = UIBarButtonItemSpecialNone;
    }
}

- (void)setBarButtonItemOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected {
    UIBarButtonItem * barButtonItem = side == UIBarButtonItemSideLeft ? self.navigationItem.leftBarButtonItem : self.navigationItem.rightBarButtonItem;
    UIButton * customViewButton = (UIButton *)barButtonItem.customView;
    customViewButton.selected = isSelected;
//    NSLog(@"customViewButton.selected set to %d", isSelected);
}

- (void)barButtonItemTouchedDownForSelection:(UIButton *)button {
    button.selected = !button.selected;
}

- (void) barButtonItemDraggedOutForSelection:(UIButton *)button {
    button.selected = !button.selected;
}
- (void) barButtonItemDraggedInForSelection:(UIButton *)button {
    button.selected = !button.selected;
}
- (void) barButtonItemTouchedUpOutsideForSelection:(UIButton *)button {
    // ...
}

- (void)backBarButtonItemTouchedUp {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemTouchedUp:(UIButton *)button {
    [self barButtonItemTouchedUpOnSide:UIBarButtonItemSideLeft asSpecialButton:self.leftBarButtonItemSpecial isSelected:button.isSelected];
}

- (void)rightBarButtonItemTouchedUp:(UIButton *)button {
    [self barButtonItemTouchedUpOnSide:UIBarButtonItemSideRight asSpecialButton:self.rightBarButtonItemSpecial isSelected:button.isSelected];
}

- (void)barButtonItemTouchedUpOnSide:(UIBarButtonItemSide)side asSpecialButton:(UIBarButtonItemSpecial)specialButton isSelected:(BOOL)isSelected {
    NSLog(@"barButtonItemTouchedUpOnSide:%d asSpecialButton:%d isSelected:%d", side, specialButton, isSelected);
    switch (specialButton) {
            
        case UIBarButtonItemSpecialSearch:
            [self setIsSearchVisible:!self.isSearchVisible animated:YES];
            break;
            
        case UIBarButtonItemSpecialStar:
            [self.favoritesController setFavorite:isSelected];
            break;
            
        case UIBarButtonItemSpecialNone:
        default:
            [self barButtonItemTouchedUpOnSide:UIBarButtonItemSideLeft isSelected:isSelected];
            break;
            
    }
}

- (void)barButtonItemTouchedUpOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected {
    // ...
    // Subclasses should override this method.
    // ...
}

- (void)setIsSearchVisible:(BOOL)isSearchVisible {
    [self setIsSearchVisible:isSearchVisible animated:NO];
}

- (void)setIsSearchVisible:(BOOL)shouldBeVisible animated:(BOOL)animated {
    if (_isSearchVisible != shouldBeVisible) {
        _isSearchVisible = shouldBeVisible;
        [self showSearchViews:self.isSearchVisible animated:animated];
    }
}

- (void) showSearchViews:(BOOL)shouldShowSearch animated:(BOOL)animated {
    void(^viewChangesBlock)(void) = ^{
        self.searchContainerView.alpha = shouldShowSearch ? self.searchContainerViewVisibleAlpha : self.searchContainerViewHiddenAlpha;
        CGRect searchContainerViewFrame = self.searchContainerView.frame;
        searchContainerViewFrame.origin.y = shouldShowSearch ? self.searchContainerViewVisibleOriginY : self.searchContainerViewHiddenOriginY;
        self.searchContainerView.frame = searchContainerViewFrame;
    };
    void(^firstResponderBlock)(void) = ^{
        if (shouldShowSearch) {
            [self.searchViewController.searchTextField becomeFirstResponder];
        } else {
            [self.searchViewController.searchTextField resignFirstResponder];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            viewChangesBlock();
            firstResponderBlock();
        } completion:^(BOOL finished) {
            // ...
        }];
    } else {
        viewChangesBlock();
        firstResponderBlock();
    }
}

- (FCFavoritesController *)favoritesController {
    if (_favoritesController == nil) {
        _favoritesController = [[FCFavoritesController alloc] initWithDelegate:self];
    }
    return _favoritesController;
}

- (FCSearchViewController *)searchViewController {
    NSUInteger searchViewControllerIndex = [self.childViewControllers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[FCSearchViewController class]];
    }];
    FCSearchViewController * searchViewController = nil;
    if (searchViewControllerIndex != NSNotFound) {
        searchViewController = self.childViewControllers[searchViewControllerIndex];
        searchViewController.delegate = self;
    }
    return searchViewController;
}

#pragma mark - FCFavoritesControllerDelegate

- (NSString *)objectClassForFavoritesController:(FCFavoritesController *)favoritesController { return nil; }
- (NSString *)objectIDForFavoritesController:(FCFavoritesController *)favoritesController    { return nil; }
- (void)favoritesController:(FCFavoritesController *)favoritesController willMakeObjectOfClass:(NSString *)objectClass withObjectID:(NSString *)objectID favorite:(BOOL)makeFavorite { /* ... */ }
- (void)favoritesController:(FCFavoritesController *)favoritesController didMakeObjectOfClass:(NSString *)objectClass withObjectID:(NSString *)objectID favorite:(BOOL)makeFavorite error:(NSError *)error {
    if (!error) {
        if (self.leftBarButtonItemSpecial == UIBarButtonItemSpecialStar)
            [self setBarButtonItemOnSide:UIBarButtonItemSideLeft isSelected:makeFavorite];
        if (self.rightBarButtonItemSpecial == UIBarButtonItemSpecialStar)
            [self setBarButtonItemOnSide:UIBarButtonItemSideRight isSelected:makeFavorite];
    }
}

#pragma mark - FCSearchViewControllerDelegate

- (void)searchViewControllerWillFindObjects:(FCSearchViewController *)searchViewController {
    // ...
}

- (void)searchViewController:(FCSearchViewController *)searchViewController didFindObjects:(NSArray *)objects error:(NSError *)error {
    // ...
}

@end
