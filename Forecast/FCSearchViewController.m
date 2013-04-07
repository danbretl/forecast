//
//  FCSearchViewController.m
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCSearchViewController.h"
#import "FCCategoryCell.h"

@interface FCSearchViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@end

@implementation FCSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.shouldSearchProjects = YES;
        self.shouldSearchArtists = YES;
        self.shouldReturnLocations = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchPlaceholderTextForCurrentScope];
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    
    if (self.categories.count == 0) {
        [[FCParseManager sharedInstance] getCategoriesInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.categories = objects;
            [self.collectionView reloadData];
        }];
    }
}

- (void)setShouldSearchProjects:(BOOL)shouldSearchProjects {
    _shouldSearchProjects = shouldSearchProjects;
    [self setSearchPlaceholderTextForCurrentScope];
}

- (void)setShouldSearchArtists:(BOOL)shouldSearchArtists {
    _shouldSearchArtists = shouldSearchArtists;
    [self setSearchPlaceholderTextForCurrentScope];
}

- (void)setSearchPlaceholderTextForCurrentScope {
    self.searchTextField.placeholder = [NSString stringWithFormat:@"%@%@%@", self.shouldSearchProjects ? @"Project" : @"", self.shouldSearchProjects && self.shouldSearchArtists ? @" or " : @"", self.shouldSearchArtists ? @"Artist" : @""];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1 + self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FCCategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FCCategoryCell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell setViewsForFavorites];
    } else {
        [cell setViewsForCategory:self.categories[indexPath.item - 1]];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@%@", NSStringFromSelector(_cmd), indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@%@", NSStringFromSelector(_cmd), indexPath);    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchForObjects];
    return NO;
}

- (void)searchForObjects {
    if ([self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 3 &&
        self.collectionView.indexPathsForSelectedItems.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Not enough information" message:@"Your search is a bit too general. Try to be more specific." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        if ([self.delegate respondsToSelector:@selector(searchViewControllerWillFindObjects:)]) {
            [self.delegate searchViewControllerWillFindObjects:self];
        }
        BOOL favoritesOnly = NO;
        NSArray * categoryIDs = nil;
        if (self.collectionView.indexPathsForSelectedItems.count > 0) {
            NSMutableIndexSet * indexes = [NSMutableIndexSet indexSet];
            for (NSIndexPath * indexPath in self.collectionView.indexPathsForSelectedItems) {
                if (indexPath.item == 0) {
                    favoritesOnly = YES;
                } else {
                    [indexes addIndex:indexPath.item];
                }
            }
            categoryIDs = [[self.categories objectsAtIndexes:indexes] valueForKey:@"objectId"];
        }
        [[FCParseManager sharedInstance] getSearchResultsForTerm:self.searchTextField.text includeProjects:self.shouldSearchProjects andArtists:self.shouldSearchArtists favoritesOnly:favoritesOnly inCategoriesWithCategoryIDs:categoryIDs returnLocations:self.shouldReturnLocations inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"[FCParseManager sharedInstance] getSearchResultsForTerm:%@ includeProjects:%d andArtists:%d favoritesOnly:%d inCategoriesWithCategoryIDs:%@ returnLocations:%d", self.searchTextField.text, self.shouldSearchProjects, self.shouldSearchArtists, favoritesOnly, categoryIDs, self.shouldReturnLocations);
            if (!error) {
                if (self.shouldReturnLocations) {
                    NSLog(@"  %d Location objects returned", objects.count);
                    for (PFObject * location in objects) {
                        PFGeoPoint * coordinate = location[@"coordinate"];
                        NSLog(@"    Location - p(%@) a(%@) - (%f,%f)", location[@"project"][@"title"], location[@"project"][@"artist"][@"name"], coordinate.latitude, coordinate.longitude);
                    }
                } else {
                    NSLog(@"  %d SearchItem objects returned", objects.count);
                    for (PFObject * searchItem in objects) {
                        NSLog(@"    %@ - p(%@) a(%@)", searchItem[@"type"], searchItem[@"project"][@"title"] ? searchItem[@"project"][@"title"] : @"", searchItem[@"artist"][@"name"] ? searchItem[@"artist"][@"name"] : @"");
                    }                    
                }
            } else {
                NSLog(@"  Error %@", error);
            }
            if ([self.delegate respondsToSelector:@selector(searchViewController:didFindObjects:error:)]) {
                [self.delegate searchViewController:self didFindObjects:objects error:error];
            }
        }];
    }
}

@end
