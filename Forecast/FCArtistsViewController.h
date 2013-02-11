//
//  FCArtistsViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewController.h"

@interface FCArtistsViewController : FCViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray * artists;
@property (nonatomic, readonly) NSArray * objects;

@end
