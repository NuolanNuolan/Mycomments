//
//  SearchTableViewCell.m
//  MyComments
//
//  Created by Bruce on 15-9-8.
//
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(10, 10, 60, 60);

    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 80;
    
    self.textLabel.frame = tmpFrame;
    
}

@end
