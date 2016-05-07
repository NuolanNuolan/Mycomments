//
//  ForgetStep2ViewController.h
//  MyComments
//
//  Created by Bruce on 16/3/21.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ForgetStep2ViewController : UIViewController
<
UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITextField *code;

@property (nonatomic,strong) NSString *cellphone;
@end
