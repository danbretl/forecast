//
//  FCProjectsViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/5/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCProjectsViewController.h"
#import "FCProjectCell.h"
#import "FCProjectViewController.h"

@interface FCProjectsViewController ()
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic) NSArray * projectSearchItems;
@end

@implementation FCProjectsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleNormal = @"Projects";
    self.titleSearchVisible = @"Search";
    self.titleSearchActive = @"Search Results";
    
    [self setRightBarButtonItemToSearchButton];
    
    self.tableView.rowHeight = [FCProjectCell heightForCell];
    
    if (self.projects.count == 0) {
        [[FCParseManager sharedInstance] getProjectsForArtistWithID:nil inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.projects = objects;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewProject"]) {
        FCProjectViewController * projectViewController = segue.destinationViewController;
        projectViewController.project = [self objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    } else if ([segue.identifier isEqualToString:@"EmbedSearchProjects"]) {
        FCSearchViewController * searchViewController = segue.destinationViewController;
        searchViewController.shouldSearchArtists = NO;
        searchViewController.shouldSearchProjects = YES;
        searchViewController.shouldReturnLocations = NO;
    }
}

#pragma mark Public methods

- (NSArray *)objects {
    return self.isSearchActive ? self.projectSearchItems : self.projects;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * object = self.objects[indexPath.row];
    if (self.isSearchActive) object = object[@"project"];
    return object;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    FCProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
    
    // Configure cell
    [cell setViewsForProject:[self objectAtIndexPath:indexPath]];
    
    // Return cell
    return cell;
    
}

#pragma mark - FCSearchViewControllerDelegate

- (void)searchViewControllerWillFindObjects:(FCSearchViewController *)searchViewController {
    [super searchViewControllerWillFindObjects:searchViewController];
}

- (void)searchViewController:(FCSearchViewController *)searchViewController didFindObjects:(NSArray *)objects error:(NSError *)error {
    [super searchViewController:searchViewController didFindObjects:objects error:error];
    self.isSearchActive = objects.count > 0;
    if (objects.count > 0) {
        self.projectSearchItems = objects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setIsSearchVisible:NO animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"No matching artists" message:@"We couldn't find any matching artists for your search. Please adjust your search and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (BOOL)searchViewControllerShouldResetAll:(FCSearchViewController *)searchViewController {
    return [super searchViewControllerShouldResetAll:searchViewController] && YES;
}

- (void)searchViewControllerDidResetAll:(FCSearchViewController *)searchViewController {
    [super searchViewControllerDidResetAll:searchViewController];
    self.isSearchActive = NO;
    self.projectSearchItems = nil;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
