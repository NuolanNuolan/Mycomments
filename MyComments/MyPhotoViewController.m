//
//  PhotoViewController.m
//  MyComments
//
//  Created by Bruce on 15-9-11.
//
//

#import "MyPhotoViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"
#import "ShopDetailViewController.h"

@interface MyPhotoViewController ()

@property (nonatomic,assign) NSUInteger gpage;

@property (nonatomic,retain) UITapGestureRecognizer *tap;
@property (nonatomic,retain) NSMutableArray *photos;
@property (nonatomic,assign) NSString *cusername;


@end

@implementation MyPhotoViewController

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
    
    //self.photoBrowser = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
    
    //self.tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    if(self.cusername){
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Photos",self.cusername];
    }else{
        self.navigationItem.title = @"My Photos";
    }
    
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
    
    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{
        [self.myCollectionView.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    
    [self refreshingData:++self.gpage callback:^{
        [self.myCollectionView.footer endRefreshing];
    }];
}



- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"myPhotos"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    if(self.cusername){
        [postData setValue:self.cusername forKey:@"username"];
    }else{
        [postData setValue:[NSString stringWithFormat:@"%@",[BWCommon getUserInfo:@"username"]] forKey:@"username"];
    }
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            NSMutableDictionary *data = [responseObject objectForKey:@"msg"];
            
            
            if(page == 1)
            {
                dataArray = [[data objectForKey:@"lists"] mutableCopy];
            }
            else
            {
                [dataArray addObjectsFromArray:[[data objectForKey:@"lists"] mutableCopy]];
                
            }
            
            self.photos = [[NSMutableArray alloc] init];
            

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
        [hud removeFromSuperview];
        MYLOG(@"请求失败");
    }];
    
    
}

-(void) setValue:(NSString *)usernameValue{
    self.cusername = usernameValue;
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
        
        NSString *image_url = [[dataArray objectAtIndex:imageIndex ] objectForKey:@"small_image"];
        
        NSString *image_url1 = [NSString stringWithFormat:@"%@/uploadfiles/%@!m%ldx%ld.jpg",[BWCommon getBaseInfo:@"site_url"],image_url,width,height ];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:image_url1] placeholderImage:[UIImage imageNamed:@"appicon.png"] options:SDWebImageCacheMemoryOnly];
        
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, width, 20)];
        titleLabel.text = [[dataArray objectAtIndex:imageIndex] objectForKey:@"shop_name"];
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
    
    ShopDetailViewController *viewController = [[ShopDetailViewController alloc] init];
    self.detailDelegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
    NSInteger sid = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"sid"] integerValue];
    [self.detailDelegate setValue:sid];
    
    
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
