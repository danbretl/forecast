//
//  FCTableViewCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCTableViewCell.h"
#import "FCColoredDisclosureIndicator.h"

@interface FCTableViewCell()
- (void) setSubviewLabelsHighlightedColorsToNormalColors:(UIView *)superview;
@end

@implementation FCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Normal background view
    UIView * normalBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    normalBackgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = normalBackgroundView;

    // Selected background view
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"diagonal_tile"]] colorWithAlphaComponent:0.5];
    self.selectedBackgroundView = selectedBackgroundView;
    
    // Highlighted color of labels
    [self setSubviewLabelsHighlightedColorsToNormalColors:self];
    
    // Disclosure indicator
    FCColoredDisclosureIndicator * accessory = [FCColoredDisclosureIndicator accessoryWithColor:[UIColor colorWithWhite:51.0/255.0 alpha:1.0]];
    accessory.highlightedColor = accessory.accessoryColor;
    self.accessoryView = accessory;
}

- (void) setSubviewLabelsHighlightedColorsToNormalColors:(UIView *)superview {
    for (UIView * view in superview.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)view;
            label.highlightedTextColor = label.textColor;
        }
        [self setSubviewLabelsHighlightedColorsToNormalColors:view];
    }
}

@end
