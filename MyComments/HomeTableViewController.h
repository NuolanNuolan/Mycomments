//
//  HomeTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface HomeTableViewController : UITableViewController
<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSArray *popularCityArray;

@end
