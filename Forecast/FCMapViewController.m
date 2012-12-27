//
//  FCMapViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCMapViewController.h"
#import "FCLocation.h"

@interface FCMapViewController ()

@end

@implementation FCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.locations.count == 0) {
        [[FCParseManager sharedInstance] getLocationsForProjectWithID:nil inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSMutableArray * objectsLocal = [NSMutableArray array];
            for (PFObject * object in objects) {
                FCLocation * location = [FCLocation locationFromPFLocationObject:object];
                [objectsLocal addObject:location];
                NSLog(@"Added location object %@", location);
            }
            self.locations = objectsLocal;
            [self addLocationsToMap:self.locations];
        }];
    }
}

- (void)addLocationsToMap:(NSArray *)locations {
    [self.mapView addAnnotations:locations];
}

@end
