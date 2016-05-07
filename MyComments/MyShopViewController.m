//
//  ShopTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import "MyShopViewController.h"
#import "ShopTableViewFrame.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface MyShopViewController ()

@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic,assign) NSUInteger gpage;


@end

@implementation MyShopViewController

NSArray *cityData;
NSArray *provinceData;
//NSArray *townData;

NSArray *categoryData;
NSArray *subCategoryData;

NSMutableArray *filterData;

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pagelayout];
}

- (void) pagelayout{
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = @"MyComments";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-42)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    

    //NSLog(@"%@",categoryData);

    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{}];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    
}

- (void) headerRefreshing{
    
    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{
        [self.tableView.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    
    [self refreshingData:++self.gpage callback:^{
        [self.tableView.footer endRefreshing];
    }];
}


- (void) setValue:(NSUInteger)region_id cid:(NSUInteger)cid region_name:(NSString *)region_name cat_name:(NSString *)cat_name{
    
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [BWCommon getHUD];
    //hud.mode = MBProgressHUDModeCustomView;
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"search"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];

    
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
            
            self.tableView.footer.hidden = (dataArray.count <=0) ? YES : NO;
            
            self.statusFrames = nil;
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            
            
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailViewController *viewController = [[ShopDetailViewController alloc] init];
    self.detailDelegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
    NSInteger sid = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"sid"] integerValue];
    [self.detailDelegate setValue:sid];
    
}



//DOP Dropdown menu end.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopTableViewFrame *vf = self.statusFrames[indexPath.row];
    
    return vf.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopTableViewCell *cell = [ShopTableViewCell cellWithTableView:tableView];
    
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}



- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            ShopTableViewFrame *vf = [[ShopTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    
    return _statusFrames;
}

@end
