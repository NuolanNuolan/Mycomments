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
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
MBProgressHUDDelegate
>
{
//    MBProgressHUD *hud;
}

- (void) snapImage;//拍照
- (void) pickImage;//从相册里找

@end
