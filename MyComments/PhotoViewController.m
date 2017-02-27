//
//  PhotoViewController.m
//  MyComments
//
//  Created by Bruce on 15-9-11.
//
//

#import "PhotoViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"


@interface PhotoViewController ()
{

    //图片水印
    UIImage *image_watermark;
    //原始图片水印
    UIImage *original_image_watermark;
    
}

@property (nonatomic,assign) NSUInteger gpage;
@property (nonatomic,strong) NSMutableArray *original_image_watermark_Arr;
@property (nonatomic,retain) UITapGestureRecognizer *tap;
@property (nonatomic,retain) NSMutableArray *photos;


@end

@implementation PhotoViewController

CGSize size;

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
    
}


- (void)magnifyImage:(UITapGestureRecognizer *) tap
{
    MYLOG(@"%@",tap);

    //[ImageBrowser showImage:(UIImageView *)tap.view];//调用方法
}

- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;

    
    self.photos = [[NSMutableArray alloc] init];
//    _original_image_watermark_Arr = [NSMutableArray arrayWithCapacity:0];
    //self.photoBrowser = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
    
    //self.tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = self.shop_name;
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
     self.myCollectionView.delegate = self;
     self.myCollectionView.dataSource = self;
     
     [self.view addSubview:self.myCollectionView];
    
    
    //[self.view addGestureRecognizer:tap];
    
    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{}];
    
    [self.myCollectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.myCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.myCollectionView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.myCollectionView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.myCollectionView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.myCollectionView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];


}
- (void) headerRefreshing{
    @weakify(self);
    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{
        @strongify(self);
        [self.myCollectionView.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    @weakify(self);

    [self refreshingData:++self.gpage callback:^{
            @strongify(self);
        [self.myCollectionView.footer endRefreshing];
    }];
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
//        MWPhoto *photo = [self.photos objectAtIndex:index];
//        MYLOG(@"%@",photo);

//        photo.underlyingImage = [UIImage imageNamed:@"watermark"];
//        return photo;
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    hud.delegate=self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"photos"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",self.sid] forKey:@"sid"];
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [MBProgressHUD hideHUDForView:self.view];
        if(code == 200)
        {
            NSMutableDictionary *data = [responseObject objectForKey:@"data"];
            
            
            if(page == 1)
            {
                dataArray = [[data objectForKey:@"lists"] mutableCopy];
            }
            else
            {
                [dataArray addObjectsFromArray:[[data objectForKey:@"lists"] mutableCopy]];
                
            }
            
            self.photos = [[NSMutableArray alloc] init];

            for(NSInteger i=0;i<[dataArray count];i++){
                NSString *image_url = [[dataArray objectAtIndex:i ] objectForKey:@"original_image"];
                NSString *image_url2 = [NSString stringWithFormat:@"%@/uploadfiles/%@!w640x800.jpg",[BWCommon getBaseInfo:@"site_url"],image_url];
                MYLOG(@"%@",[NSString stringWithFormat:@"%@/uploadfiles/%@",[BWCommon getBaseInfo:@"site_url"],image_url]);
                //这个图片地址是经过剪切的
                
                [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:image_url2]]];
            
            }
            MYLOG(@"%@",dataArray);
            
            [self.myCollectionView reloadData];
            
            if(callback){
                callback();
            }
            
        }
        else
        {
            MYLOG(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view];
        MYLOG(@"请求失败");
    }];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //return (int) ceilf( [dataArray count] / 2.0 );
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    
    //NSInteger imageIndex = indexPath.section * 2 + indexPath.row;
    NSInteger imageIndex = indexPath.row;
    
    MYLOG(@"%ld",imageIndex);
    
    if (imageIndex < [dataArray count])
    {
        
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        NSInteger width = size.width / 2 - 10;
        NSInteger height = width * 0.75;
        NSInteger x;

        x = 0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, width, height)];
        
        NSString *image_url = [[dataArray objectAtIndex:imageIndex ] objectForKey:@"original_image"];
    
        NSString *image_url1 = [NSString stringWithFormat:@"%@/uploadfiles/%@!m%ldx%ld.jpg",[BWCommon getBaseInfo:@"site_url"],image_url,width,height ];
        [imageView sd_setImageWithURL:[NSURL URLWithString:image_url1] placeholderImage:[UIImage imageNamed:@"appicon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            imageView.image =[self addToImage:image image:[UIImage imageNamed:@"watermark"] withRect:CGMAKE(width-55, height-15, 55, 15)];
            
            [cell.contentView addSubview:imageView];
        }];
        
        
        
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, width, 20)];
        titleLabel.text = [[dataArray objectAtIndex:imageIndex] objectForKey:@"title"];
        [titleLabel setFont: [UIFont systemFontOfSize:14]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [cell.contentView addSubview:titleLabel];
        
        //[imageView addGestureRecognizer:self.tap];

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(size.width / 2-10, size.width / 2 - 20);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0,5,0,0);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    self.browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    self.browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    self.browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    self.browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    self.browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    self.browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    self.browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    self.browser.autoPlayOnAppear = NO; // Auto-play first video
    
    [self.browser setCurrentPhotoIndex:indexPath.row];
    [self.browser showNextPhotoAnimated:YES];
    [self.browser showPreviousPhotoAnimated:YES];
    // Present
    [self.navigationController pushViewController:self.browser animated:YES];
    
    
}
- (UIImage *) addToImage:(UIImage *)img image:(UIImage *)newImage withRect:(CGRect)rect

{
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    [newImage drawInRect:rect];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return aimg;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
