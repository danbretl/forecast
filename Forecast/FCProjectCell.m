//
//  FCProjectCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCProjectCell.h"
#import "PFImageView+Placeholder.h"

@interface FCProjectCell()
@property (nonatomic, weak) IBOutlet UIView * projectCategoryColorView;
@property (nonatomic, weak) IBOutlet PFImageView * projectImageView;
@property (nonatomic, weak) IBOutlet UILabel * projectNameLabel;
@end

@implementation FCProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCell {
    return 56.0;
}

- (void)setViewsForProject:(PFObject *)project {
    
    self.projectCategoryColorView.backgroundColor = [UIColor colorWithRed:[project[@"category"][@"colorRed"] floatValue] green:[project[@"category"][@"colorGreen"] floatValue] blue:[project[@"category"][@"colorBlue"] floatValue] alpha:1.0];
    [self.projectImageView setImageWithFile:project[@"profileImage"] placeholder:nil];
    self.projectNameLabel.text = project[@"title"];
    
}

@end
