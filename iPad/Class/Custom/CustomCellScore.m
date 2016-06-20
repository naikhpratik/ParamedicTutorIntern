//
//  CustomCell_quiz.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import "CustomCellScore.h"

@interface CustomCellScore ()

@end

@implementation CustomCellScore
@synthesize lab_title, lab_result;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
//    img_answer_.userInteractionEnabled = NO;
//    tfAnswer.editable = NO;
//    tfAnswer.userInteractionEnabled = NO;
}


- (void)dealloc {
    [lab_title release];
    [lab_result release];
    [super dealloc];
}


@end
