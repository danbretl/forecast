//
//  FCLocation.m
//  Forecast
//
//  Created by Dan Bretl on 12/27/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCLocation.h"

@interface FCLocation()
@property (nonatomic) PFObject * pfLocation;
@end

@implementation FCLocation

+ (FCLocation *)locationFromPFLocationObject:(PFObject *)pfLocationObject {
    FCLocation * location = [[FCLocation alloc] init];
    location.pfLocation = pfLocationObject;
    return location;
}

- (PFObject *)project {
    return self.pfLocation[@"project"];
}

- (NSString *)title {
    return self.pfLocation[@"project"][@"title"];
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@"/* - %@"*/, self.pfLocation[@"name"]/*, self.pfLocation[@"project"][@"artist"][@"name"]*/];
}

- (CLLocationCoordinate2D)coordinate {
    PFGeoPoint * geoPoint = self.pfLocation[@"coordinate"];
    return CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@) at (%f,%f)", self.title, self.subtitle, self.coordinate.latitude, self.coordinate.longitude];
}

@end
