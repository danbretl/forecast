//
//  FCProjectsViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/5/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCProjectsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray * projects;
@property (nonatomic, readonly) NSArray * objects;

@end
