//
//  ForgetStep3ViewController.h
//  MyComments
//
//  Created by Bruce on 16/3/21.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ForgetStep3ViewController : UIViewController
<
UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UITextField *confirmpassword;

@property (nonatomic,strong) NSString *cellphone;
@end
