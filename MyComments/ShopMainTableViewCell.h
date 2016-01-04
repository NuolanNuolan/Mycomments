//
//  ShopMainTableViewCell.h
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ShopMainTableViewFrame.h"

@interface ShopMainTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopMainTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) UIImageView *mainImage;
@property (nonatomic,weak) UIButton *imageButton;

@end
