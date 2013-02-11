//
//  FCArtistViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewController.h"

@interface FCArtistViewController : FCViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) PFObject * artist;

@end
