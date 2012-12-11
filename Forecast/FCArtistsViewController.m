//
//  FCArtistsViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/4/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCArtistsViewController.h"
#import "FCArtistCell.h"
#import "PFImageView+Placeholder.h"
#import "FCArtistViewController.h"

@interface FCArtistsViewController ()
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@end

@implementation FCArtistsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.artists.count == 0) {
        [[FCParseManager sharedInstance] getArtistsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.artists = objects;
            [self.tableView reloadData];
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

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    FCArtistCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
    
    // Get data
    PFObject * artist = self.artists[indexPath.row];
    
    // Configure cell
    [cell.artistImageView setImageWithFile:artist[@"profileImage"] placeholder:nil];
    cell.artistNameLabel.text = artist[@"name"];
    
    // Return cell
    return cell;
    
}

@end
