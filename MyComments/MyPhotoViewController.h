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
#import "DetailDelegate.h"
//#import "MWPhotoBrowser.h"
#import "MJRefresh.h"
#import "MemberDelegate.h"

@interface MyPhotoViewController : UIViewController
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
//MWPhotoBrowserDelegate,
MemberDelegate,
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic,assign) id<DetailDelegate> detailDelegate;

//@property (nonatomic,strong) MWPhotoBrowser *browser;

@end
