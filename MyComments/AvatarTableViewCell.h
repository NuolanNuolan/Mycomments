//
//  UserTableViewCell.h
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import <UIKit/UIKit.h>
#import "AvatarTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface AvatarTableViewCell : UITableViewCell

@property (nonatomic,strong) AvatarTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;
@property (nonatomic,retain) UIImageView *avatarImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
