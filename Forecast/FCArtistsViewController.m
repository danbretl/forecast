//
//  FCArtistsViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCArtistsViewController.h"
#import "FCArtistCell.h"
#import "FCArtistViewController.h"

@interface FCArtistsViewController ()
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic) NSArray * artistSearchItems;
@end

@implementation FCArtistsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleNormal = @"Artists";
    self.titleSearchVisible = @"Search";
    self.titleSearchActive = @"Search Results";
    
    [self setRightBarButtonItemToSearchButton];
    
    self.tableView.rowHeight = [FCArtistCell heightForCell];
    
    if (self.artists.count == 0) {
        [[FCParseManager sharedInstance] getArtistsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.artists = objects;
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
    if ([segue.identifier isEqualToString:@"ViewArtist"]) {
        FCArtistViewController * artistViewController = segue.destinationViewController;
        artistViewController.artist = [self objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    } else if ([segue.identifier isEqualToString:@"EmbedSearchArtists"]) {
        FCSearchViewController * searchViewController = segue.destinationViewController;
        searchViewController.shouldSearchArtists = YES;
        searchViewController.shouldSearchProjects = NO;
        searchViewController.shouldReturnLocations = NO;
    }
}

#pragma mark Public methods

- (NSArray *)objects {
    return self.isSearchActive ? self.artistSearchItems : self.artists;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * object = self.objects[indexPath.row];
    if (self.isSearchActive) object = object[@"artist"];
    return object;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    FCArtistCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
    
    // Configure cell
    [cell setViewsForArtist:[self objectAtIndexPath:indexPath]];
    
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
        self.artistSearchItems = objects;
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
    self.artistSearchItems = nil;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
