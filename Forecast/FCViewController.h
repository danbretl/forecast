//
//  FCViewController.h
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//
//  This class is a superclass of basically all view controllers in the project. It allows us to reliably customize the appearance of navigation bars throughout the app. This should really be done once in the app delegate, but that hasn't been working so far. That is most certainly due to human error, but this human doesn't have time to figure it out just now, and this temporary solution does not really have any serious drawbacks (nor would it be hard to undo later when the proper solution is successfully implemented).

#import <UIKit/UIKit.h>

typedef enum {
    UIBarButtonItemSideLeft  = 1,
    UIBarButtonItemSideRight = 2,
} UIBarButtonItemSide;

@interface FCViewController : UIViewController

- (UIBarButtonItem *) setBackBarButtonItemToArrowButton;
- (void) clearLeftBarButtonItem;

- (UIBarButtonItem *) setRightBarButtonItemToSearchButton;
- (UIBarButtonItem *) setRightBarButtonItemToStarButton;
- (void) clearRightBarButtonItem;

- (void) barButtonItemTouchedOnSide:(UIBarButtonItemSide)side; // Subclasses should override this method

@end
