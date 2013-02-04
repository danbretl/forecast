//
//  FCArtistCell.m
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCArtistCell.h"
#import "PFImageView+Placeholder.h"

@interface FCArtistCell()
@property (nonatomic, weak) IBOutlet PFImageView * artistImageView;
@property (nonatomic, weak) IBOutlet UILabel * artistNameLabel;
@end

@implementation FCArtistCell

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

- (void)setViewsForArtist:(PFObject *)artist {
    
    [self.artistImageView setImageWithFile:artist[@"profileImage"] placeholder:nil];
    self.artistNameLabel.text = artist[@"name"];
    
}

@end
