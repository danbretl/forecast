//
//  FCNeverClearView.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCNeverClearView.h"

@implementation FCNeverClearView

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (![backgroundColor isEqual:[UIColor clearColor]]) {
        [super setBackgroundColor:backgroundColor];
    }
}

@end
