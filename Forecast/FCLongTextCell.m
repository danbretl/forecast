//
//  FCLongTextCell.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCLongTextCell.h"
#import "PFImageView+Placeholder.h"

#define kLongTextCellWidth 320.0 // Making this hardcoded value explicit
#define kLongTextCellPadding 10.0
#define kLongTextCellImageLength 50.0
#define kLongTextCellTextFontName @"Helvetica"
#define kLongTextCellTextFontSize 14.0

@interface FCLongTextCell()
@property (nonatomic, weak) IBOutlet PFImageView * introImageView;
@property (nonatomic, weak) IBOutlet UILabel * longTextLabel;
@end

@implementation FCLongTextCell

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

+ (CGFloat)heightForCellWithText:(NSString *)text imageVisible:(BOOL)isImageVisible {
    
    return CGRectGetMaxY([self frameForText:text imageVisible:isImageVisible]) + kLongTextCellPadding;
    
}

+ (CGRect)frameForText:(NSString *)text imageVisible:(BOOL)isImageVisible {
    
    CGRect textFrame = CGRectZero;
    textFrame.origin.x = kLongTextCellPadding;
    if (isImageVisible) textFrame.origin.x += kLongTextCellPadding + kLongTextCellImageLength;
    textFrame.origin.y = kLongTextCellPadding;
    textFrame.size.width = kLongTextCellWidth - kLongTextCellPadding - textFrame.origin.x;
    textFrame.size.height = [text sizeWithFont:[UIFont fontWithName:kLongTextCellTextFontName size:kLongTextCellTextFontSize] constrainedToSize:CGSizeMake(textFrame.size.width, 5000.0) lineBreakMode:UILineBreakModeWordWrap].height;
    return textFrame;
    
}

- (void)setText:(NSString *)text imageFile:(PFFile *)imageFile {
    
    BOOL isImageVisible = imageFile != nil;
    if (isImageVisible) {
        [self.introImageView setImageWithFile:imageFile placeholder:nil];
    }
    self.longTextLabel.text = text;
    self.longTextLabel.frame = [FCLongTextCell frameForText:text imageVisible:isImageVisible];
    
}

@end
