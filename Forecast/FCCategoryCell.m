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

- (void)setViewsForCategory:(PFObject *)category {
    self.categoryLabel.text = category[@"name"];
    [self.categoryImageView setImageWithFile:category[@"icon"] placeholder:nil];
}

@end
