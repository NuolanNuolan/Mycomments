//
//  RegionTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-9-9.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RegionTableViewController : UITableViewController
<
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
}
@property (nonatomic,retain) NSMutableArray *dataArray;

@end
