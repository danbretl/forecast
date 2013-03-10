//
//  FCCategoryCell.h
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCCategoryCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet PFImageView * categoryImageView;
@property (nonatomic, weak) IBOutlet UILabel * categoryLabel;

- (void) setViewsForCategory:(PFObject *)category;

@end
