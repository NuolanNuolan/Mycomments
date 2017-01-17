//
//  ShopTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ShopDelegate.h"
#import "DetailDelegate.h"
#import "DOPDropDownMenu.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ShopViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
ShopDelegate,
MBProgressHUDDelegate,
CLLocationManagerDelegate,
DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *dataArray;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,assign) id<ShopDelegate> delegate;
@property (nonatomic,assign) id<DetailDelegate> detailDelegate;

@property (nonatomic,strong) CLLocationManager *manager;

@end
