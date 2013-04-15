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
- (void)removeAllLocationsFromMap;
- (void)zoomToMinnesotaAnimated:(BOOL)animated; // Hardcoded map region
- (void)zoomToFitAnnotations:(NSArray *)locations animated:(BOOL)animated; // Uses hardcoded constants for minimumZoomRectLengthInMeters and edgePaddingInPoints
- (void)zoomToFitAnnotations:(NSArray *)locations minimumZoomRectLengthInMeters:(double)minimumZoomRectLengthInMeters edgePaddingInPoints:(UIEdgeInsets)edgePaddingInPoints animated:(BOOL)animated;
@property (nonatomic) NSArray * locationsSearchResults;
@end

@implementation FCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleNormal = @"Map";
    self.titleSearchVisible = @"Search";
    self.titleSearchActive = @"Search Results";
    
    [self setRightBarButtonItemToSearchButton];
    
    if (self.locations.count == 0) {
        [[FCParseManager sharedInstance] getLocationsForProjectWithID:nil inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.locations = [FCLocation locationsFromPFLocationObjects:objects];
            [self addLocationsToMap:self.locations];
            [self zoomToFitAnnotations:self.locations animated:YES];
        }];
    } else {
        [self zoomToFitAnnotations:self.locations animated:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self zoomToFitAnnotations:self.isSearchActive ? self.locationsSearchResults : self.locations animated:YES];
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmbedSearchMap"]) {
        FCSearchViewController * searchViewController = segue.destinationViewController;
        searchViewController.shouldSearchArtists = YES;
        searchViewController.shouldSearchProjects = YES;
        searchViewController.shouldReturnLocations = YES;
    }
}

- (void)addLocationsToMap:(NSArray *)locations {
    [self.mapView addAnnotations:locations];
}

- (void)removeAllLocationsFromMap {
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)zoomToMinnesotaAnimated:(BOOL)animated {
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.072042, -94.010513), MKCoordinateSpanMake(5.594572, 7.031250)) animated:animated];
}

- (void)zoomToFitAnnotations:(NSArray *)locations animated:(BOOL)animated {
    [self zoomToFitAnnotations:locations minimumZoomRectLengthInMeters:2000.0 edgePaddingInPoints:UIEdgeInsetsMake(44.0, 44.0, 44.0, 44.0) animated:animated];
}

- (void)zoomToFitAnnotations:(NSArray *)locations minimumZoomRectLengthInMeters:(double)minimumZoomRectLengthInMeters edgePaddingInPoints:(UIEdgeInsets)edgePaddingInPoints animated:(BOOL)animated {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    NSLog(@"  minimumZoomRectLengthInMeters = %f", minimumZoomRectLengthInMeters);
    MKMapRect zoomRect = MKMapRectNull;
    for (id<MKAnnotation> location in locations) {
        MKMapPoint mapPoint = MKMapPointForCoordinate(location.coordinate);
        MKMapRect mapPointRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, mapPointRect);
    }
    NSLog(@"  zoomRect = %@", NSStringFromCGRect(CGRectMake(zoomRect.origin.x, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height)));
    MKCoordinateRegion coordinateRegionForZoomRect = MKCoordinateRegionForMapRect(zoomRect);
    NSLog(@"  coordinateRegionForZoomRect = (%f, %f) (%f, %f)", coordinateRegionForZoomRect.center.latitude, coordinateRegionForZoomRect.center.longitude, coordinateRegionForZoomRect.span.latitudeDelta, coordinateRegionForZoomRect.span.longitudeDelta);
    double pointsPerMeter = MKMapPointsPerMeterAtLatitude(coordinateRegionForZoomRect.center.latitude);
    NSLog(@"  pointsPerMeter = %f", pointsPerMeter);
    double zoomRectWidthMetersDifferenceFromMinimum  = zoomRect.size.width  / pointsPerMeter - minimumZoomRectLengthInMeters;
    NSLog(@"  zoomRectWidthMetersDifferenceFromMinimum = %f", zoomRectWidthMetersDifferenceFromMinimum);
    double zoomRectHeightMetersDifferenceFromMinimum = zoomRect.size.height / pointsPerMeter - minimumZoomRectLengthInMeters;
    NSLog(@"  zoomRectHeightMetersDifferenceFromMinimum = %f", zoomRectWidthMetersDifferenceFromMinimum);
    
    MKMapRect zoomRectAdjusted = zoomRect;
    
    if (zoomRectWidthMetersDifferenceFromMinimum  < 0 ||
        zoomRectHeightMetersDifferenceFromMinimum < 0) {
        zoomRectAdjusted = MKMapRectInset(zoomRect, zoomRectWidthMetersDifferenceFromMinimum, zoomRectHeightMetersDifferenceFromMinimum);
        NSLog(@"  zoomRect(adjustedToMin) = %@", NSStringFromCGRect(CGRectMake(zoomRectAdjusted.origin.x, zoomRectAdjusted.origin.y, zoomRectAdjusted.size.width, zoomRectAdjusted.size.height)));
    }
    
    NSLog(@"  edgePaddingInPoints = %@", NSStringFromUIEdgeInsets(edgePaddingInPoints));
    zoomRectAdjusted = [self.mapView mapRectThatFits:zoomRectAdjusted edgePadding:edgePaddingInPoints];
    NSLog(@"  zoomRect(adjustedToFitWithPadding) = %@", NSStringFromCGRect(CGRectMake(zoomRectAdjusted.origin.x, zoomRectAdjusted.origin.y, zoomRectAdjusted.size.width, zoomRectAdjusted.size.height)));

    [self.mapView setVisibleMapRect:zoomRectAdjusted animated:animated];
    
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

- (void)barButtonItemTouchedUpOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected {
    if (side == UIBarButtonItemSideRight) {
        [self setIsSearchVisible:!self.isSearchVisible animated:YES];
    }
}

#pragma mark - FCSearchViewControllerDelegate

- (void)searchViewControllerWillFindObjects:(FCSearchViewController *)searchViewController {
    [super searchViewControllerWillFindObjects:searchViewController];
}

- (void)searchViewController:(FCSearchViewController *)searchViewController didFindObjects:(NSArray *)objects error:(NSError *)error {
    [super searchViewController:searchViewController didFindObjects:objects error:error];
    self.isSearchActive = objects.count > 0;
    if (objects.count > 0) {
        self.locationsSearchResults = [FCLocation locationsFromPFLocationObjects:objects];
        [self removeAllLocationsFromMap];
        [self addLocationsToMap:self.locationsSearchResults];
        [self zoomToFitAnnotations:self.locationsSearchResults animated:YES];
        [self setIsSearchVisible:NO animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"No matching results" message:@"We couldn't find any matching results for your search. Please adjust your search and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (BOOL)searchViewControllerShouldResetAll:(FCSearchViewController *)searchViewController {
    return [super searchViewControllerShouldResetAll:searchViewController] && YES;
}

- (void)searchViewControllerDidResetAll:(FCSearchViewController *)searchViewController {
    [super searchViewControllerDidResetAll:searchViewController];
    self.isSearchActive = NO;
    self.locationsSearchResults = nil;
    [self removeAllLocationsFromMap];
    [self addLocationsToMap:self.locations];
    [self zoomToFitAnnotations:self.locations animated:YES];
}

@end
