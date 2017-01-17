//
//  MemberTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MemberDelegate.h"

@interface MemberTableViewController : UITableViewController
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
MemberDelegate,
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,assign) id<MemberDelegate> memberDelegate;

@end
