//
//  AddMerchantViewController.h
//  MyComments
//
//  Created by Bruce on 15/9/27.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddMerchantViewController : UIViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
MBProgressHUDDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate
>
{
    MBProgressHUD *hud;
}

- (void) snapImage;//拍照
- (void) pickImage;//从相册里找

@end
