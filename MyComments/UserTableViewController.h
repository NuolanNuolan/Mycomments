//
//  UserTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface UserTableViewController : UITableViewController
<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@end
