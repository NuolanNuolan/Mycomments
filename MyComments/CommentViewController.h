//
//  CommentViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "DetailDelegate.h"
#import "MemberDelegate.h"

@interface CommentViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
MemberDelegate,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *dataArray;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) id<DetailDelegate> detailDelegate;
@property (nonatomic,assign) BOOL myComments;
@property (nonatomic,assign) BOOL ismyComments;
@property (nonatomic,assign) id<MemberDelegate> memberDelegate;

@end
