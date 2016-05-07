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
#import "ImageBrowser.h"

@interface MyPhotoViewController ()

@property (nonatomic,assign) NSUInteger gpage;

@end

@implementation MyPhotoViewController

CGSize size;

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
    
}



- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.username = [BWCommon getUserInfo:@"username"];
   
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 's photos",self.username];
    
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
    
    
    
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"myPhotos"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:self.username forKey:@"username"];
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
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
            
            NSLog(@"%@",dataArray);
            
            [self.myCollectionView reloadData];
            
            if(callback){
                callback();
            }
            
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
    }];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (int) ceilf( [dataArray count] / 2.0 );
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    
    NSInteger imageIndex = indexPath.section * 2 + indexPath.row;
    
    NSLog(@"%ld",imageIndex);
    
    if (imageIndex < [dataArray count])
    {
        NSInteger width = size.width / 2 - 20;
        NSInteger height = width * 0.75;
        NSInteger x;
        if (indexPath.row == 0){
            x=10;
        }else{
            x=0;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, width, height)];
        
        NSString *image_url = [[dataArray objectAtIndex:imageIndex ] objectForKey:@"original_image"];
        
        image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@!m%ldx100.jpg",[BWCommon getBaseInfo:@"site_url"],image_url,width ];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"appicon.png"] options:SDWebImageCacheMemoryOnly];
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, width, 20)];
        titleLabel.text = [[dataArray objectAtIndex:imageIndex] objectForKey:@"title"];
        [titleLabel setFont: [UIFont systemFontOfSize:14]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:titleLabel];

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(size.width / 2 - 6, size.width / 2 - 20);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,0,0,0);
    
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
