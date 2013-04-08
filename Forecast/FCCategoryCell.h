//
//  FCCategoryCell.h
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kCategoryCellPaddingBottomToImageView;

@interface FCCategoryCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet PFImageView * categoryImageView;
@property (nonatomic, weak) IBOutlet UILabel * categoryLabel;

- (void) setViewsForFavorites;
- (void) setViewsForCategory:(PFObject *)category;

@end
