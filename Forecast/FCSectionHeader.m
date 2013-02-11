//
//  FCSectionHeader.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCSectionHeader.h"

@interface FCSectionHeader()
@property (nonatomic) UILabel * label;
@end

@implementation FCSectionHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:204.0/255.0 alpha:1.0];
        
        UIView * borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1.0)];
        borderTop.backgroundColor = [UIColor colorWithWhite:51.0/255.0 alpha:1.0];
        borderTop.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:borderTop];
        
        UIView * borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0)];
        borderBottom.backgroundColor = [UIColor colorWithWhite:51.0/255.0 alpha:1.0];
        borderBottom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:borderBottom];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)]; // Using a non-hardcoded value for width was causing some odd issues the first time the section header was displayed (if it started on screen) - it would be shifted slightly to the right.
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.font = [UIFont systemFontOfSize:12.0];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
