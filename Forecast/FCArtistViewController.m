//
//  FCArtistViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCArtistViewController.h"
#import "FCLongTextCell.h"
#import "FCBigImageCell.h"
#import "FCProjectCell.h"
#import "FCLinkCell.h"
#import "NSNotificationCenter+Forecast.h"
#import "TabBarConstants.h"

#define kArtistSectionBio 0
#define kArtistSectionSplashImage 1
#define kArtistSectionProjects 2
#define kArtistSectionStatement 3
#define kArtistSectionLinks 4

@interface FCArtistViewController ()
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic) PFObject * splashImageObject;
@property (nonatomic) NSArray * projects;
@property (nonatomic) NSArray * links;
@end

@implementation FCArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NOTE: We are currently making an assumption that we already have the basic artist data
    
    // Navigation bar
    NSString * artistName = self.artist[@"name"];
    self.navigationItem.title = artistName;
    self.navigationItem.backBarButtonItem.title = artistName;
    
    [self.tableView reloadData];
    
    // Get the first big image associated with the artist
    [[FCParseManager sharedInstance] getFirstImageForObjectOfClass:kParseClassArtist withID:self.artist.objectId inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.splashImageObject = (objects.count > 0) ? objects[0] : nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kArtistSectionSplashImage] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    // Get the projects associated with the artist
    [[FCParseManager sharedInstance] getProjectsForArtistWithID:self.artist.objectId inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.projects = objects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kArtistSectionProjects] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    // Get the links associated with the artist
    [[FCParseManager sharedInstance] getLinksForObjectOfClass:kParseClassArtist withID:self.artist.objectId inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.links = objects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kArtistSectionLinks] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

}

// Sections and cells:
// Section 0 : (No header)
//   - Artist bio
// Section 1 : (No header)
//   - Big splash image
// Section 2 : Projects
//   - Projects
// Section 3 : Artist Statement
//   - Artist statement
// Section 4 : Links & Contact
//   - Links

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * title = nil;
    switch (section) {
        case kArtistSectionProjects: title = @"Projects"; break;
        case kArtistSectionStatement: title = @"Artist Statement"; break;
        case kArtistSectionLinks: title = @"Links & Contact"; break;
        default: break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightForHeader = 0;
    if (section == kArtistSectionProjects ||
        section == kArtistSectionStatement ||
        section == kArtistSectionLinks) {
        heightForHeader = 30;
    }
    return heightForHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    switch (section) {
        case kArtistSectionBio:
            numberOfRows = self.artist[@"bio"] != nil ? 1 : 0;
            break;
        case kArtistSectionSplashImage:
            numberOfRows = self.splashImageObject != nil ? 1 : 0;
            break;
        case kArtistSectionProjects:
            numberOfRows = self.projects.count;
            break;
        case kArtistSectionStatement:
            numberOfRows = self.artist[@"statement"] != nil ? 1 : 0;
            break;
        case kArtistSectionLinks:
            numberOfRows = self.links.count;
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 0;
    switch (indexPath.section) {
        case kArtistSectionBio:
            heightForRow = [FCLongTextCell heightForCellWithText:self.artist[@"bio"] imageVisible:(self.artist[@"profileImage"] != nil)];
            break;
        case kArtistSectionSplashImage:
            heightForRow = [FCBigImageCell heightForCellWithCaptionVisible:self.splashImageObject[@"caption"] != nil];
            break;
        case kArtistSectionProjects:
            heightForRow = [FCProjectCell heightForCell];
            break;
        case kArtistSectionStatement:
            heightForRow = [FCLongTextCell heightForCellWithText:self.artist[@"statement"] imageVisible:NO];
            break;
        case kArtistSectionLinks:
            heightForRow = [FCLinkCell heightForCell];
            break;
        default:
            break;
    }
    return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    if (indexPath.section == kArtistSectionBio) {
        FCLongTextCell * bioCell = [tableView dequeueReusableCellWithIdentifier:@"ArtistIntroCell"];
        [bioCell setText:self.artist[@"bio"] imageFile:self.artist[@"profileImage"]];
        cell = bioCell;
    } else if (indexPath.section == kArtistSectionSplashImage) {
        FCBigImageCell * splashCell = [tableView dequeueReusableCellWithIdentifier:@"ArtistSplashCell"];
        [splashCell setBigImageFile:self.splashImageObject[@"full"] captionText:self.splashImageObject[@"caption"]];
        cell = splashCell;
    } else if (indexPath.section == kArtistSectionProjects) {
        FCProjectCell * projectCell = [tableView dequeueReusableCellWithIdentifier:@"ArtistProjectCell"];
        [projectCell setViewsForProject:self.projects[indexPath.row]];
        cell = projectCell;
    } else if (indexPath.section == kArtistSectionStatement) {
        FCLongTextCell * statementCell = [tableView dequeueReusableCellWithIdentifier:@"ArtistStatementCell"];
        [statementCell setText:self.artist[@"statement"] imageFile:nil];
        cell = statementCell;
    } else if (indexPath.section == kArtistSectionLinks) {
        FCLinkCell * linkCell = [tableView dequeueReusableCellWithIdentifier:@"ArtistLinkCell"];
        [linkCell setViewsForLink:self.links[indexPath.row]];
        cell = linkCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kArtistSectionProjects) {
        [NSNotificationCenter postSetActiveTabNotificationToDefaultCenterFromSource:self withTabIndex:kTabBarIndexProjects shouldPopToRoot:YES andPushViewControllerForParseClass:kParseClassProject withObject:self.projects[indexPath.row]];
    } else if (indexPath.section == kArtistSectionLinks) {
        [[FCParseManager sharedInstance] respondToLinkSelection:self.links[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
