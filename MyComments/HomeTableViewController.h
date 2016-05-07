//
//  HomeTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ShopDelegate.h"
#import "DetailDelegate.h"

@interface HomeTableViewController : UITableViewController
<MBProgressHUDDelegate,
CLLocationManagerDelegate
//UISearchBarDelegate,
//UISearchResultsUpdating>
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSArray *popularCityArray;

@property (nonatomic,assign) id<ShopDelegate> delegate;
@property (nonatomic,assign) id<DetailDelegate> detailDelegate;
@property (nonatomic,strong) CLLocationManager *manager;

//@property (nonatomic, strong) UISearchController *searchController;
@end
