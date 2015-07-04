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

@interface ShopTableViewController : UIViewController
<ShopDelegate,
MBProgressHUDDelegate,
UITableViewDataSource,
UITableViewDelegate,
DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate>
{
     MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) UITableView *tableView;

@end
