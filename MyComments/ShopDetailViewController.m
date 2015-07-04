//
//  ShopDetailViewController.m
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import "ShopDetailViewController.h"
#import "BWCommon.h"
#import "ShopMainTableViewCell.h"
#import "ShopMainTableViewFrame.h"
#import "AFNetworkTool.h"

@interface ShopDetailViewController ()

@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic, strong) NSArray *shopFrames;

@property (nonatomic,strong) NSArray *headTitleArray;
@property (nonatomic,strong) NSArray *headIconArray;

@property (nonatomic,assign) NSUInteger gpage;
@property (nonatomic,assign) NSUInteger sid;

@end

@implementation ShopDetailViewController

@synthesize dataArray;
@synthesize shopDict;

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagelayout];
}

- (void) pagelayout{
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = @"";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    _headTitleArray = [[NSArray alloc] initWithObjects:@"",@"Address",@"Tel",@"Website",@"Details",@"Comments", nil];
    _headIconArray = [[NSArray alloc] initWithObjects:@"",@"detail-location",@"detail-phone",@"detail-website",@"detail-details",@"detail-comment", nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];

    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    //[self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    
    [self refreshingData:self.sid callback:^{}];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if(section < 5)
        return 1;
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 0){
        return 10;
    }
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 9)];
    
    [BWCommon setBottomBorder:view color:[BWCommon getRedColor]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return  0;

    return 36;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 36)];
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    NSString *title = [_headTitleArray objectAtIndex:section];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 8, 100, 20)];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_headIconArray objectAtIndex:section]]];
    icon.frame = CGRectMake(8, 5, 24, 24);
    [view addSubview:icon];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ShopMainTableViewFrame *vf = self.shopFrames[0];
        return vf.cellHeight;
    }
    else if(indexPath.section == 1)
    {
        //计算cell高度
        CGSize addressSize = [BWCommon sizeWithString:[shopDict objectForKey:@"address"] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(size.width, MAXFLOAT)];
        return MAX(30,addressSize.height);
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        ShopMainTableViewCell *cell = [ShopMainTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.shopFrames[0];
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
    }
    
    if(indexPath.section == 1){
        cell.textLabel.text = [shopDict objectForKey:@"address"];
    }

    return cell;
    
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


- (void) refreshingData:(NSUInteger)sid callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeCustomView;
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"detail"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",sid] forKey:@"sid"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            shopDict = [responseObject objectForKey:@"data"];

            
            dataArray = [[shopDict objectForKey:@"comments"] mutableCopy];
            
            NSLog(@"%@",dataArray);
            
            self.tableView.footer.hidden = (dataArray.count <=0) ? YES : NO;
            
            self.statusFrames = nil;
            self.shopFrames = nil;
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
- (NSArray *)shopFrames
{
    if (_shopFrames == nil) {

        NSMutableArray *models = [NSMutableArray arrayWithCapacity:1];
        
        ShopMainTableViewFrame *vf = [[ShopMainTableViewFrame alloc] init];
        vf.data = [shopDict objectForKey:@"shop"];
        [models addObject:vf];
        self.shopFrames = [models copy];
        
    }
    
    return _shopFrames;
}

- (void) setValue:(NSUInteger)detailValue{
    self.sid = detailValue;
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
