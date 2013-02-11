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
@end

@implementation FCArtistsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
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
        artistViewController.artist = self.artists[[self.tableView indexPathForCell:sender].row];
    }
}

#pragma mark Public methods

- (NSArray *)objects {
    return self.artists;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    FCArtistCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
    
    // Configure cell
    [cell setViewsForArtist:self.artists[indexPath.row]];
    
    // Return cell
    return cell;
    
}

@end
