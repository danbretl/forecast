//
//  FCProjectsViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/5/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewController.h"

@interface FCProjectsViewController : FCViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray * projects;
@property (nonatomic, readonly) NSArray * objects;
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
