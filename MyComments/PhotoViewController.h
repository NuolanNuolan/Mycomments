//
//  PhotoViewController.h
//  MyComments
//
//  Created by Bruce on 15-9-11.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MWPhotoBrowser.h"
#import "MJRefresh.h"

@interface PhotoViewController : UIViewController
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MWPhotoBrowserDelegate,
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic) NSInteger sid;
@property (nonatomic) NSString *shop_name;

@property (nonatomic,strong) MWPhotoBrowser *browser;

@end
