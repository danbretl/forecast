//
//  FCCategoryCell.m
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCCategoryCell.h"
#import "PFImageView+Placeholder.h"

@implementation FCCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selected = NO;
}

- (void)setViewsForFavorites {
    self.categoryLabel.text = @"Favorites";
    self.categoryImageView.image = [UIImage imageNamed:@"nav_bar_star_light"];
}

- (void)setViewsForCategory:(PFObject *)category {
    self.categoryLabel.text = category[@"name"];
    [self.categoryImageView setImageWithFile:category[@"icon"] placeholder:nil];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.categoryLabel.backgroundColor = selected ? [UIColor whiteColor] : [UIColor clearColor];
    self.categoryLabel.textColor = selected ? [UIColor colorWithWhite:51.0/255.0 alpha:1.0] : [UIColor whiteColor];
}

@end
