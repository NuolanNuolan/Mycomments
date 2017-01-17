//
//  ShopDetailViewController.h
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MapDelegate.h"
#import "QBImagePickerController.h"
#import "MemberDelegate.h"

@interface ShopDetailViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
QBImagePickerControllerDelegate,
DetailDelegate,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,retain) NSMutableDictionary *shopDict;

@property (nonatomic,assign) id<MapDelegate> mapDelegate;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id<MemberDelegate> memberDelegate;

@property (nonatomic,assign) BOOL  isPresentview;

@end
