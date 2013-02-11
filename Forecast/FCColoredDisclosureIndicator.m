//
//  FCColoredDisclosureIndicator.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCColoredDisclosureIndicator.h"

@implementation FCColoredDisclosureIndicator

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (FCColoredDisclosureIndicator *)accessoryWithColor:(UIColor *)color {
	FCColoredDisclosureIndicator * view = [[FCColoredDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
	view.accessoryColor = color;
	return view;
}

- (void)drawRect:(CGRect)rect {
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
	CGFloat y = CGRectGetMidY(self.bounds);
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
	if (self.highlighted) {
		[self.highlightedColor setStroke];
	} else {
		[self.accessoryColor setStroke];
	}
	CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor {
	if (!_accessoryColor) {
		return [UIColor blackColor];
	}
	return _accessoryColor;
}

- (UIColor *)highlightedColor {
	if (!_highlightedColor) {
		return [UIColor whiteColor];
	}
	return _highlightedColor;
}

@end
