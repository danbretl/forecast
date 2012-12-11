//
//  PFImageView+Placeholder.h
//  Forecast
//
//  Created by Dan Bretl on 12/9/12.
//  Copyright (c) 2012 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFImageView (Placeholder)

- (void) setImageWithFile:(PFFile *)file placeholder:(UIImage *)placeholder;
- (void) setImageWithFile:(PFFile *)file placeholderNamed:(NSString *)placeholderName;

@end
