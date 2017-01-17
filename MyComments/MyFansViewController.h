//
//  ShopTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MemberDelegate.h"

@interface MyFansViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
MemberDelegate,
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
    NSMutableArray *dataArray;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end
