//
//  FCLinkCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCLinkCell.h"
#import "PFImageView+Placeholder.h"

@interface FCLinkCell()
@property (nonatomic, weak) IBOutlet PFImageView * linkTypeImageView;
@property (nonatomic, weak) IBOutlet UILabel * linkTextLabel;
@end

@implementation FCLinkCell

+ (CGFloat)heightForCell {
    return 44.0;
}

- (void)setViewsForLink:(PFObject *)link {
    [self.linkTypeImageView setImageWithFile:link[@"type"][@"image"] placeholder:nil];
    self.linkTextLabel.text = link[@"description"];
}

@end
