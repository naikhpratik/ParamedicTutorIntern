//
//  StringHelper.h
//  App
//
//  Created by Zorro on 16/05/2010.
//  Copyright 2010 Cosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (StringHelper)
- (CGFloat)RAD_textHeightForFontOfSize:(UIFont *)_font width:(CGFloat)width;
- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size width:(CGFloat)width;
- (CGFloat)RAD_textHeightForSystemBoldFontOfSize:(CGFloat)size width:(CGFloat)width;
- (CGFloat)RAD_textHeightForSystemFontOfSize_2:(CGFloat)size width:(CGFloat)width;
- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size;
- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size;
- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size;
@end
