//
//  StringHelper.m
//  App
//
//  Created by Zorro on 16/05/2010.
//  Copyright 2010 Cosoft. All rights reserved.
//

#import "StringHelper.h"



@implementation NSString (StringHelper)

#pragma mark Methods to determine the height of a string for resizeable table cells

- (CGFloat)RAD_textHeightForFontOfSize:(UIFont *)_font width:(CGFloat)width {
	CGFloat maxWidth = width;// - 50;
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:_font 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.height;
}


- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size width:(CGFloat)width{
		//Calculate the expected size based on the font and linebreak mode of your label
	//NSLog(@"width=%2f, real width=%2f", [UIScreen mainScreen].bounds.size.width, width);
	CGFloat maxWidth = width;// - 50;UILineBreakModeWordWrap
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap];
	
	return expectedLabelSize.height;
}

- (CGFloat)RAD_textHeightForSystemBoldFontOfSize:(CGFloat)size width:(CGFloat)width{
	//Calculate the expected size based on the font and linebreak mode of your label
	//NSLog(@"width=%2f, real width=%2f", [UIScreen mainScreen].bounds.size.width, width);
	CGFloat maxWidth = width - 50;
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont boldSystemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.height;
}

- (CGFloat)RAD_textHeightForSystemFontOfSize_2:(CGFloat)size width:(CGFloat)width{
	
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(width,maxHeight);
	
	CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize.height;
}

- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size {
	CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat height = [self RAD_textHeightForSystemFontOfSize:size width:[UIScreen mainScreen].bounds.size.width] + 10.0;
	return CGRectMake(10.0f, 10.0f, width, height);
}

- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size {
	aLabel.frame = [self RAD_frameForCellLabelWithSystemFontOfSize:size];
	aLabel.text = self;
	[aLabel sizeToFit];
}

- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size {
	UILabel *cellLabel = [[UILabel alloc] initWithFrame:[self RAD_frameForCellLabelWithSystemFontOfSize:size]];
	cellLabel.textColor = [UIColor blackColor];
	cellLabel.backgroundColor = [UIColor clearColor];
	cellLabel.textAlignment = UITextAlignmentLeft;
	cellLabel.font = [UIFont systemFontOfSize:size];
	
	cellLabel.text = self; 
	cellLabel.numberOfLines = 0; 
	[cellLabel sizeToFit];
	return cellLabel;
}

@end
