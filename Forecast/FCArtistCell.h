//
//  FCArtistCell.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewCell.h"

@interface FCArtistCell : FCTableViewCell

+ (CGFloat) heightForCell;

- (void) setViewsForArtist:(PFObject *)artist;

@end
