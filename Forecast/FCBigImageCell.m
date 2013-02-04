//
//  FCBigImageCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCBigImageCell.h"
#import "PFImageView+Placeholder.h"

#define kBigImageCellImageHeight 160.0
#define kBigImageCellCaptionHeight 31.0

@interface FCBigImageCell()
@property (nonatomic, weak) IBOutlet PFImageView * bigImageView;
@property (nonatomic, weak) IBOutlet UILabel * captionLabel;
@end

@implementation FCBigImageCell

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

+ (CGFloat)heightForCellWithCaptionVisible:(BOOL)isCaptionVisible {
    return kBigImageCellImageHeight + (isCaptionVisible ? kBigImageCellCaptionHeight : 0);
}

- (void)setBigImageFile:(PFFile *)imageFile captionText:(NSString *)captionText {
    [self.bigImageView setImageWithFile:imageFile placeholder:nil];
    self.captionLabel.text = captionText;
    self.captionLabel.hidden = (captionText == nil);
}

@end
