//
//  FCArtistViewController.m
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "FCArtistViewController.h"

@interface FCArtistViewController ()
@property (nonatomic, weak) IBOutlet UILabel * artistNameLabel;
@end

@implementation FCArtistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * artistName = self.artist[@"name"];
    self.artistNameLabel.text = artistName;
    self.navigationItem.title = artistName;
    self.navigationItem.backBarButtonItem.title = artistName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
