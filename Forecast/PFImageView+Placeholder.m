//
//  PFImageView+Placeholder.m
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import "PFImageView+Placeholder.h"

@implementation PFImageView (Placeholder)

- (void) setImageWithFile:(PFFile *)file placeholder:(UIImage *)placeholder {
    self.image = placeholder;
    self.file = file;
    [self loadInBackground];
}
- (void) setImageWithFile:(PFFile *)file placeholderNamed:(NSString *)placeholderName {
    [self setImageWithFile:file placeholder:[UIImage imageNamed:placeholderName]];
}

@end
