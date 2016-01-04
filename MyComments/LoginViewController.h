//
//  LoginViewController.h
//  MyComments
//
//  Created by Bruce on 15-9-10.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface LoginViewController : UIViewController
<
UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITextField *username;
@property (nonatomic,strong) UITextField *password;

@end
