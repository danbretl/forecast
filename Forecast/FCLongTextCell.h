//
//  FCLongTextCell.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCLongTextCell : UITableViewCell

+ (CGFloat) heightForCellWithText:(NSString *)text imageVisible:(BOOL)isImageVisible;

- (void) setText:(NSString *)text imageFile:(PFFile *)imageFile;

@end
