//
//  FCProjectCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCProjectCell.h"
#import "PFImageView+Placeholder.h"
#import "FCNeverClearView.h"

@interface FCProjectCell()
@property (nonatomic, weak) IBOutlet FCNeverClearView * projectCategoryColorView;
@property (nonatomic, weak) IBOutlet PFImageView * projectImageView;
@property (nonatomic, weak) IBOutlet UILabel * projectNameLabel;
@end

@implementation FCProjectCell

+ (CGFloat)heightForCell {
    return 58.0;
}

- (void)setViewsForProject:(PFObject *)project {
    
    self.projectCategoryColorView.backgroundColor = [UIColor colorWithRed:[project[@"category"][@"colorRed"] floatValue] green:[project[@"category"][@"colorGreen"] floatValue] blue:[project[@"category"][@"colorBlue"] floatValue] alpha:1.0];
    [self.projectImageView setImageWithFile:project[@"profileImage"] placeholder:nil];
    self.projectNameLabel.text = project[@"title"];
    
}

@end
