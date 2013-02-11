//
//  FCLinkCell.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewCell.h"

@interface FCLinkCell : FCTableViewCell

+ (CGFloat) heightForCell;

- (void) setViewsForLink:(PFObject *)link; // link should include its type

@end
