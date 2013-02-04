//
//  FCArtistCell.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCArtistCell : UITableViewCell

+ (CGFloat) heightForCell;

- (void) setViewsForArtist:(PFObject *)artist;

@end
