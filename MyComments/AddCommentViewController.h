//
//  AddMerchantViewController.h
//  MyComments
//
//  Created by Bruce on 15/9/27.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddCommentViewController : UIViewController
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
MBProgressHUDDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
UITextViewDelegate
>
{
    MBProgressHUD *hud;
}

@end
