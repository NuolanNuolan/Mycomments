//
//  Register2ViewController.h
//  MyComments
//
//  Created by Bruce on 15/9/27.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Register2ViewController : UIViewController
<
UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITextField *username;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UITextField *code;

@property (nonatomic,strong) NSString *cellphone;
@end
