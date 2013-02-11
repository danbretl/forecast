//
//  FCMapViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCMapViewController.h"
#import "FCLocation.h"
#import "NSNotificationCenter+Forecast.h"
#import "TabBarConstants.h"
#import "FCProjectViewController.h"

@interface FCMapViewController ()
- (void)addLocationsToMap:(NSArray *)locations;
- (void)zoomToMinnesotaAnimated:(BOOL)animated; // Hardcoded map region
@end

@implementation FCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButtonItemToSearchButton];
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
            [self zoomToMinnesotaAnimated:YES];
        }];
    }
}

- (void)addLocationsToMap:(NSArray *)locations {
    [self.mapView addAnnotations:locations];
}

- (void)zoomToMinnesotaAnimated:(BOOL)animated {
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.072042, -94.010513), MKCoordinateSpanMake(5.594572, 7.031250)) animated:animated];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    // TWO OPTIONS
    // We could either navigate to (and push a project view controller onto) the projects tab, OR we could just push a project view controller on top of the map...

    // OPTION 1: Push a project view controller on top of the map
//    FCProjectViewController * projectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FCProjectViewController"];
//    projectViewController.project = ((FCLocation *)view.annotation).project;
//    [self.navigationController pushViewController:projectViewController animated:YES];

    // OPTION 2: Navigate to projects tab
    [NSNotificationCenter postSetActiveTabNotificationToDefaultCenterFromSource:self withTabIndex:kTabBarIndexProjects shouldPopToRoot:YES andPushViewControllerForParseClass:kParseClassProject withObject:((FCLocation *)view.annotation).project];
    
}

// Debugging
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    NSLog(@"(%f, %f) - (%f, %f)", mapView.region.center.latitude, mapView.region.center.longitude, mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
//}

@end
