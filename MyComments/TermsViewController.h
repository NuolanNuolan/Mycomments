//
//  TermsViewController.h
//  MyComments
//
//  Created by Bruce on 16/3/20.
//
//

#import <UIKit/UIKit.h>
#import "BWCommon.h"
#import "MBProgressHUD.h"

@interface TermsViewController : UIViewController
<UIWebViewDelegate>
{
}

@property(nonatomic,unsafe_unretained)int tag;

@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,retain) UIWebView *webView;
@end
