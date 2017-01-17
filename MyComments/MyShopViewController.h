//
//  ShopTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import <UIKit/UIKit.h>
#import "ShopDelegate.h"
#import "DetailDelegate.h"
#import "DOPDropDownMenu.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MemberDelegate.h"

@interface MyShopViewController : UIViewController
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

@property (nonatomic,assign) id<DetailDelegate> detailDelegate;

@end
