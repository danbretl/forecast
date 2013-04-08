//
//  FCSearchViewController.m
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import "FCSearchViewController.h"
#import "FCCategoryCell.h"

const CGFloat kSearchCategoriesCollectionViewImageLengthMax = 100.0;

@interface FCSearchViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, weak) IBOutlet UIButton * resetButton;
- (IBAction)resetButtonTouched:(id)sender;
- (void)setResetButtonStateForCurrentControls;
@property (nonatomic) BOOL isModifiedForSearch;
- (void)searchTextFieldTextDidChange:(NSNotification *)notificaton;
@property (nonatomic, readonly) NSString * textForSearch;
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
    
    [self setResetButtonStateForCurrentControls];
    
}

- (void)viewDidLayoutSubviews {
    UICollectionViewFlowLayout * collectionViewFlowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat categoriesCollectionViewImageLength = MIN(kSearchCategoriesCollectionViewImageLengthMax, self.collectionView.bounds.size.height);
    collectionViewFlowLayout.itemSize = CGSizeMake(categoriesCollectionViewImageLength, categoriesCollectionViewImageLength);
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
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

- (void)resetAllAnimated:(BOOL)animated {
    [self resetSelectionsAnimated:animated];
    [self resetSearchText];
    self.isModifiedForSearch = NO;
    [self setResetButtonStateForCurrentControls];
}

- (void)resetSelectionsAnimated:(BOOL)animated {
    if (animated) {
        for (NSIndexPath * indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:animated];
        }
    } else {
        [self.collectionView reloadData];
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    [self setResetButtonStateForCurrentControls];
}

- (void)resetSearchText {
    self.searchTextField.text = nil;
}

- (void)resetButtonTouched:(id)sender {
    BOOL shouldResetAll = YES;
    if ([self.delegate respondsToSelector:@selector(searchViewControllerShouldResetAll:)]) {
        shouldResetAll = [self.delegate searchViewControllerShouldResetAll:self];
    }
    if (shouldResetAll) {
        [self resetAllAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(searchViewControllerDidResetAll:)]) {
            [self.delegate searchViewControllerDidResetAll:self];
        }
    }
}

- (void)setResetButtonStateForCurrentControls {
    self.resetButton.enabled = self.collectionView.indexPathsForSelectedItems.count > 0 || self.searchTextField.text.length > 0;
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
    [self setResetButtonStateForCurrentControls];
    self.isModifiedForSearch = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@%@", NSStringFromSelector(_cmd), indexPath);
    [self setResetButtonStateForCurrentControls];
    self.isModifiedForSearch = YES;
}

- (void)searchTextFieldTextDidChange:(NSNotification *)notificaton {
    [self setResetButtonStateForCurrentControls];
    self.isModifiedForSearch = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchForObjects];
    return NO;
}

- (NSString *) textForSearch {
    return [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isReadyForSearch {
    return (self.collectionView.indexPathsForSelectedItems.count > 0 || self.textForSearch.length > 0);
}

- (void)searchForObjects {
    if (!self.isReadyForSearch) {
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
        [[FCParseManager sharedInstance] getSearchResultsForTerm:self.textForSearch includeProjects:self.shouldSearchProjects andArtists:self.shouldSearchArtists favoritesOnly:favoritesOnly inCategoriesWithCategoryIDs:categoryIDs returnLocations:self.shouldReturnLocations inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"[FCParseManager sharedInstance] getSearchResultsForTerm:%@ includeProjects:%d andArtists:%d favoritesOnly:%d inCategoriesWithCategoryIDs:%@ returnLocations:%d", self.textForSearch, self.shouldSearchProjects, self.shouldSearchArtists, favoritesOnly, categoryIDs, self.shouldReturnLocations);
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
                self.isModifiedForSearch = NO;
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
