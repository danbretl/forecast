//
//  FCProjectViewController.m
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCProjectViewController.h"
#import "FCLongTextCell.h"
#import "FCBigImageCell.h"
#import "FCLinkCell.h"
#import "FCSectionHeader.h"

#define kProjectSectionIntro 0
#define kProjectSectionSplashImage 1
#define kProjectSectionArtistBio 2
#define kProjectSectionLinks 3

@interface FCProjectViewController ()
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic) PFObject * splashImageObject;
@property (nonatomic) NSArray * links;
@end

@implementation FCProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NOTE: We are currently making an assumption that we already have the basic project data
    
    // Navigation bar
    NSString * projectName = self.project[@"title"];
    self.navigationItem.title = projectName;
    self.navigationItem.backBarButtonItem.title = projectName;
    [self setBackBarButtonItemToArrowButton]; // This is the back button that will show when THIS view controller is at the top of the navigation stack. This is a bit different from the way Apple does it.
    [self setRightBarButtonItemToStarButton];
    
    [self.tableView reloadData];
    
    // Get the first big image associated with the project
    [[FCParseManager sharedInstance] getFirstImageForObjectOfClass:kParseClassProject withID:self.project.objectId inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.splashImageObject = (objects.count > 0) ? objects[0] : nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectSectionSplashImage] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
        
    // Get the links associated with the project
    [[FCParseManager sharedInstance] getLinksForObjectOfClass:kParseClassProject withID:self.project.objectId inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.links = objects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectSectionLinks] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    // Get whether this project is a favorite
    [self setBarButtonItemOnSide:UIBarButtonItemSideRight isSelected:[[FCParseManager sharedInstance] isFavoriteObjectWithClass:kParseClassProject withID:self.project.objectId forceServerCheckInBackgroundWithBlock:^(PFObject *favorite, NSError *error) {
        if (!error) [self setBarButtonItemOnSide:UIBarButtonItemSideRight isSelected:favorite != nil && [favorite[@"isFavorite"] boolValue]];
    }]];
    
}

// Sections and cells:
// Section 0 : (No header)
//   - Project intro
// Section 1 : (No header)
//   - Big splash image
// Section 2 : About the Artist
//   - Artist bio
// Section 3 : Project Links & Documents
//   - Links

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * title = nil;
    switch (section) {
        case kProjectSectionArtistBio: title = @"About the Artist"; break;
        case kProjectSectionLinks: title = @"Project Links & Documents"; break;
        default: break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightForHeader = 0;
    if (section == kProjectSectionArtistBio ||
        section == kProjectSectionLinks) {
        heightForHeader = 30;
    }
    return heightForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FCSectionHeader * sectionHeader = [[FCSectionHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    sectionHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sectionHeader.label.text = [self tableView:tableView titleForHeaderInSection:section].uppercaseString;
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    switch (section) {
        case kProjectSectionIntro:
            numberOfRows = self.project[@"description"] != nil ? 1 : 0;
            break;
        case kProjectSectionSplashImage:
            numberOfRows = self.splashImageObject != nil ? 1 : 0;
            break;
        case kProjectSectionArtistBio:
            numberOfRows = self.project[@"artist"][@"bio"] != nil ? 1 : 0;
            break;
        case kProjectSectionLinks:
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
        case kProjectSectionIntro:
            heightForRow = [FCLongTextCell heightForCellWithText:self.project[@"description"] imageVisible:(self.project[@"profileImage"] != nil)];
            break;
        case kProjectSectionSplashImage:
            heightForRow = [FCBigImageCell heightForCellWithCaptionVisible:self.splashImageObject[@"caption"] != nil];
            break;
        case kProjectSectionArtistBio:
            heightForRow = [FCLongTextCell heightForCellWithText:self.project[@"artist"][@"bio"] imageVisible:(self.project[@"artist"][@"profileImage"] != nil)];
            break;
        case kProjectSectionLinks:
            heightForRow = [FCLinkCell heightForCell];
            break;
        default:
            break;
    }
    return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    if (indexPath.section == kProjectSectionIntro) {
        FCLongTextCell * introCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectIntroCell"];
        [introCell setText:self.project[@"description"] imageFile:self.project[@"category"][@"icon"]];
        cell = introCell;
    } else if (indexPath.section == kProjectSectionSplashImage) {
        FCBigImageCell * splashCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectSplashCell"];
        [splashCell setBigImageFile:self.splashImageObject[@"full"] captionText:self.splashImageObject[@"caption"]];
        cell = splashCell;
    } else if (indexPath.section == kProjectSectionArtistBio) {
        FCLongTextCell * artistBioCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectArtistBioCell"];
        [artistBioCell setText:self.project[@"artist"][@"bio"] imageFile:self.project[@"artist"][@"profileImage"]];
        cell = artistBioCell;
    } else if (indexPath.section == kProjectSectionLinks) {
        FCLinkCell * linkCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectLinkCell"];
        [linkCell setViewsForLink:self.links[indexPath.row]];
        cell = linkCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kProjectSectionLinks) {
        [[FCParseManager sharedInstance] respondToLinkSelection:self.links[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FCViewController method overrides

- (void)barButtonItemTouchedUpOnSide:(UIBarButtonItemSide)side isSelected:(BOOL)isSelected {
    if (side == UIBarButtonItemSideRight) {
        [[FCParseManager sharedInstance] setFavorite:isSelected objectOfClass:kParseClassProject withID:self.project.objectId inBackgroundWithBlock:^(PFObject *favorite, NSError *error) {
            NSLog(@"favorite : %@", favorite);
            NSLog(@"error : %@", error);
            if (!error) [self setBarButtonItemOnSide:side isSelected:[favorite[@"isFavorite"] boolValue]];
        }];
    }
}

@end
