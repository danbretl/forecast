//
//  FCMapViewController.h
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FCMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic) NSArray * locations; // Array of FCLocation objects

@property (nonatomic) IBOutlet MKMapView * mapView;

@end
