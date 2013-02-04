//
//  FCProjectViewController.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCProjectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) PFObject * project;

@end
