//
//  ShopTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import <UIKit/UIKit.h>
#import "ShopDelegate.h"
#import "DOPDropDownMenu.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ShopViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
ShopDelegate,
MBProgressHUDDelegate,
DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *dataArray;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end
