//
//  FCProjectCell.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewCell.h"

@interface FCProjectCell : FCTableViewCell

+ (CGFloat) heightForCell;

- (void) setViewsForProject:(PFObject *)project; // project should include its category object

@end
