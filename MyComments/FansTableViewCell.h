//
//  ShopTableViewCell.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import <UIKit/UIKit.h>
#import "FansTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface FansTableViewCell : UITableViewCell

@property (nonatomic,strong) FansTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
