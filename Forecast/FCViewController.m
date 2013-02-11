//
//  FCViewController.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCViewController.h"

@interface FCViewController ()
- (UIBarButtonItem *)setBarButtonItemOnSide:(UIBarButtonItemSide)side isBackButton:(BOOL)isBackButton toCustomButtonWithImageNameLight:(NSString *)imageNameLight imageNameDark:(NSString *)imageNameDark;
- (void) clearBarButtonItemOnSide:(UIBarButtonItemSide)side;
- (void) backBarButtonItemTouched;
- (void) leftBarButtonItemTouched;
- (void) rightBarButtonItemTouched;
@end

@implementation FCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Customize appearance
    // Navigation Bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_str"] forBarMetrics:UIBarMetricsDefault];
}

- (UIBarButtonItem *)setBackBarButtonItemToArrowButton {
    return [self setBarButtonItemOnSide:UIBarButtonItemSideLeft isBackButton:YES toCustomButtonWithImageNameLight:@"nav_bar_back_light" imageNameDark:@"nav_bar_back_dark"];
}

- (UIBarButtonItem *)setRightBarButtonItemToSearchButton {
    return [self setBarButtonItemOnSide:UIBarButtonItemSideRight isBackButton:NO toCustomButtonWithImageNameLight:@"nav_bar_glass_light" imageNameDark:@"nav_bar_glass_dark"];
}

- (UIBarButtonItem *)setRightBarButtonItemToStarButton {
    return [self setBarButtonItemOnSide:UIBarButtonItemSideRight isBackButton:NO toCustomButtonWithImageNameLight:@"nav_bar_star_light" imageNameDark:@"nav_bar_star_dark"];
}

- (UIBarButtonItem *)setBarButtonItemOnSide:(UIBarButtonItemSide)side isBackButton:(BOOL)isBackButton toCustomButtonWithImageNameLight:(NSString *)imageNameLight imageNameDark:(NSString *)imageNameDark {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageNameLight] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"clear"] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameDark] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[[UIImage imageNamed:@"white"] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 40.0, 40.0);
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    SEL selector = @selector(backBarButtonItemTouched);
    if (side == UIBarButtonItemSideLeft) {
        self.navigationItem.leftBarButtonItem = barButton;
        if (!isBackButton) selector = @selector(leftBarButtonItemTouched);
    } else if (side == UIBarButtonItemSideRight) {
        self.navigationItem.rightBarButtonItem = barButton;
        if (!isBackButton) selector = @selector(rightBarButtonItemTouched);
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
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
    } else if (side == UIBarButtonItemSideRight) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)backBarButtonItemTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemTouched {
    [self barButtonItemTouchedOnSide:UIBarButtonItemSideLeft];
}

- (void)rightBarButtonItemTouched {
    [self barButtonItemTouchedOnSide:UIBarButtonItemSideRight];
}

- (void)barButtonItemTouchedOnSide:(UIBarButtonItemSide)side {
    // ...
    // Subclasses should override this method.
    // ...
}

@end
