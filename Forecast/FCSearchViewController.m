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
    if (indexPath.row == 0) {
        [cell setViewsForFavorites];
    } else {
        [cell setViewsForCategory:self.categories[indexPath.row - 1]];
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
    if ([self.delegate respondsToSelector:@selector(searchViewControllerWillFindObjects:)]) {
        [self.delegate searchViewControllerWillFindObjects:self];
    }
    [[FCParseManager sharedInstance] getSearchResultsForTerm:self.searchTextField.text includeProjects:self.shouldSearchProjects andArtists:self.shouldSearchArtists inBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"[FCParseManager sharedInstance] getSearchResultsForTerm:%@ includeProjects:%d andArtists:%d", self.searchTextField.text, self.shouldSearchProjects, self.shouldSearchArtists);
        NSLog(@"  objects = %@", objects);
        NSLog(@"  error   = %@", error);
        if ([self.delegate respondsToSelector:@selector(searchViewController:didFindObjects:error:)]) {
            [self.delegate searchViewController:self didFindObjects:objects error:error];
        }
    }];
}

@end
