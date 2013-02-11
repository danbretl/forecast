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
@end

@implementation FCProjectsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
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
        projectViewController.project = self.projects[[self.tableView indexPathForCell:sender].row];
    }
}

#pragma mark Public methods

- (NSArray *)objects {
    return self.projects;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    FCProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
    
    // Configure cell
    [cell setViewsForProject:self.projects[indexPath.row]];
    
    // Return cell
    return cell;
    
}

@end
