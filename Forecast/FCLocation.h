//
//  FCLocation.h
//  Forecast
//
//  Created by Dan Bretl on 12/27/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FCLocation : NSObject <MKAnnotation>

+ (FCLocation *) locationFromPFLocationObject:(PFObject *)pfLocationObject;

@property (nonatomic, readonly) PFObject * project;

@end
