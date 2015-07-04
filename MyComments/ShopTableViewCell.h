//
//  ShopTableViewCell.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import <UIKit/UIKit.h>
#import "ShopTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface ShopTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
