//
//  FCSearchViewController.h
//  Forecast
//
//  Created by Dan Bretl on 3/10/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCSearchViewControllerDelegate;

@interface FCSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSArray * categories;
@property (nonatomic) BOOL shouldSearchProjects;
@property (nonatomic) BOOL shouldSearchArtists;
@property (nonatomic) BOOL shouldReturnLocations;
- (void) searchForObjects;

@property (nonatomic, weak) IBOutlet UITextField * searchTextField;

@property (nonatomic, weak) id<FCSearchViewControllerDelegate> delegate;

@end

@protocol FCSearchViewControllerDelegate <NSObject>
@optional
- (void) searchViewControllerWillFindObjects:(FCSearchViewController *)searchViewController;
- (void) searchViewController:(FCSearchViewController *)searchViewController didFindObjects:(NSArray *)objects error:(NSError *)error;
@end
