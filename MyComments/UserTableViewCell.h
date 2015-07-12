//
//  UserTableViewCell.h
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import <UIKit/UIKit.h>
#import "UserTableViewFrame.h"

@interface UserTableViewCell : UITableViewCell

@property (nonatomic,strong) UserTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;
@property (nonatomic,retain) UIImageView *iconImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
