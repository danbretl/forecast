//
//  FCMapViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FCViewController.h"

@interface FCMapViewController : FCViewController <MKMapViewDelegate>

@property (nonatomic) NSArray * locations; // Array of FCLocation objects

@property (nonatomic, weak) IBOutlet MKMapView * mapView;

@end
