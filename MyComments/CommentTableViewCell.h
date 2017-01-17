//
//  CommentTableViewCell.h
//  MyComments
//
//  Created by Bruce He on 15/7/3.
//
//

#import <UIKit/UIKit.h>
#import "CommentTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,strong) CommentTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) UIButton *memberButton;

@end
