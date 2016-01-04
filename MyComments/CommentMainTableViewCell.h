//
//  CommentMainTableViewCell.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//


#import <UIKit/UIKit.h>
#import "CommentMainTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface CommentMainTableViewCell : UITableViewCell

@property (nonatomic,strong) CommentMainTableViewFrame *viewFrame;
@property (nonatomic) BOOL hasName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) UIButton *likeButton;

@end
