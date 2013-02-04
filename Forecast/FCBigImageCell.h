//
//  FCBigImageCell.h
//  Forecast
//
//  Created by Dan Bretl on 2/3/13.
//  Copyright (c) 2013 Dan Bretl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCBigImageCell : UITableViewCell

+ (CGFloat) heightForCellWithCaptionVisible:(BOOL)isCaptionVisible;

- (void) setBigImageFile:(PFFile *)imageFile captionText:(NSString *)captionText;

@end
