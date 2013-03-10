//
//  FCSearchViewController.h
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray * categories;

@end
