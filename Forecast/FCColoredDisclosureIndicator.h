//
//  FCColoredDisclosureIndicator.h
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCColoredDisclosureIndicator : UIControl

@property (nonatomic) UIColor * accessoryColor;
@property (nonatomic) UIColor * highlightedColor;

+ (FCColoredDisclosureIndicator *)accessoryWithColor:(UIColor *)color;

@end