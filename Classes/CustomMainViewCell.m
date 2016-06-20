//
//  CustomMainViewCell.m
//  Quiz
//
//  Created by perry on 9/25/13.
//
//

#import "CustomMainViewCell.h"

@implementation CustomMainViewCell
@synthesize imgView_content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
