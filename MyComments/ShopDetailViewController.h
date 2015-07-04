//
//  ShopDetailViewController.h
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ShopDetailViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
DetailDelegate,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,retain) NSMutableDictionary *shopDict;

@property (nonatomic,strong) UITableView *tableView;

@end
