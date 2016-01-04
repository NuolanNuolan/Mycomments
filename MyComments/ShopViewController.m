//
//  ShopTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-3.
//
//

#import "ShopViewController.h"
#import "ShopTableViewFrame.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface ShopViewController ()

@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic,assign) NSUInteger region_id;
@property (nonatomic,assign) NSUInteger cid;
@property (nonatomic,assign) NSUInteger gpage;
@property (nonatomic,assign) NSString *o;
@property (nonatomic,assign) NSUInteger ot;

@property (nonatomic,assign) NSString *region_name;
@property (nonatomic,assign) NSString *cat_name;


@property (nonatomic,strong) DOPDropDownMenu *menu;


@end

@implementation ShopViewController

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
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, size.width, size.height-42)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    
    provinceData = [BWCommon loadRegions:1 initData:@"Location"];
    categoryData = [BWCommon getDataInfo:@"category"];
    
    //NSLog(@"%@",categoryData);
    
    //Default, Rate Descending , Rate Ascending, Price Ascending, Price Descending,Nearest
    
    filterData = [[NSMutableArray alloc] initWithCapacity:6];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Default",@"name",@"",@"o",@"0",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Rate Descending",@"name",@"rate",@"o",@"2",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Rate Ascending",@"name",@"rate",@"o",@"1",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Price Ascending",@"name",@"price",@"o",@"1",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Price Descending",@"name",@"price",@"o",@"2",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Nearest",@"name",@"nearest",@"o",@"2",@"ot", nil]];
    
    //NSLog(@"%@",filterData);
    
    
    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    [self.menu setSeparatorColor:[UIColor whiteColor]];
    //self.menu.indicatorColor = [BWCommon getMainColor];
    //self.menu.textSelectedColor = [BWCommon getMainColor];
    //self.menu.textColor = [BWCommon getMainColor];
    
    self.menu.delegate = self;
    self.menu.dataSource = self;
    
    
    [self.view addSubview:self.menu];
    
    //初始化
    self.o = @"";
    self.ot = 0;
    
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
    
    self.region_id = region_id;
    self.cid = cid;
    self.region_name = region_name;
    self.cat_name = cat_name;
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [BWCommon getHUD];
    //hud.mode = MBProgressHUDModeCustomView;
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"search"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.region_id] forKey:@"region_id"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.cid] forKey:@"cid"];
    [postData setValue:self.o forKey:@"o"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.ot] forKey:@"ot"];
  
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


// DOP Dropdown Menu begin
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    
    return 3;
    
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return [provinceData count];
    }
    else if(column == 1) {
        return [categoryData count];
    }
    else if(column == 2) {
        return [filterData count];
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column == 0) {
        
        //if(self.region_id>0 && indexPath.row == 0){
        //    return [BWCommon getRegionById:self.region_id];
        //}
        return [[provinceData objectAtIndex:[indexPath row]] objectForKey:@"region_name"];
        //return [[provinceData allValues] objectAtIndex:[indexPath row]];
    }
    else if(indexPath.column == 1){
        
        return [[categoryData objectAtIndex:[indexPath row]] objectForKey:@"cat_name"];
    }
    else if (indexPath.column == 2){
        return [[filterData objectAtIndex:[indexPath row]] objectForKey:@"name"];
    }
    
    return @"";
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    
    if(column == 0){
        
        NSUInteger parent_id =[[[provinceData objectAtIndex:row] objectForKey:@"region_id"]
                               integerValue];
        
        cityData = [BWCommon loadRegions:parent_id initData:@""];
        NSLog(@"%@",cityData);
        return [cityData count];
    }
    else if(column == 1){
        
        subCategoryData = [self subCategory:row];
        return [subCategoryData count];
    }
    
    return 0;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column == 0) {
        
        NSUInteger parent_id =[[[provinceData objectAtIndex:indexPath.row] objectForKey:@"region_id"]
                               integerValue];
        
        cityData = [BWCommon loadRegions:parent_id initData:@""];
        
        return [[cityData objectAtIndex:indexPath.item] objectForKey:@"region_name"];
        
    }
    else if(indexPath.column == 1){
        //subCategoryData = [[categoryData objectAtIndex:indexPath.row] objectForKey:@"childrens"];
        subCategoryData = [self subCategory:indexPath.row];
        return [[subCategoryData objectAtIndex:indexPath.item] objectForKey:@"cat_name"];
    }
    return nil;
    
}
-(void) menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if(indexPath.column == 0){
        
        NSLog(@"item %ld",indexPath.item);
        NSLog(@"row %ld",indexPath.row);
        
        if (indexPath.item >= 0){
            NSUInteger parent_id =[[[provinceData objectAtIndex:indexPath.row] objectForKey:@"region_id"]
                                   integerValue];
            cityData = [BWCommon loadRegions:parent_id initData:@""];
            self.region_id = [[[cityData objectAtIndex:indexPath.item] objectForKey:@"region_id"] integerValue];
            [self refreshingData:1 callback:^{}];
        }
        
        if(indexPath.row == 0){
            self.region_id = 0;
            [self refreshingData:1 callback:^{}];
        }
    }
    else if (indexPath.column == 1){
        if (indexPath.item >= 0){
            //subCategoryData = [[categoryData objectAtIndex:indexPath.row] objectForKey:@"childrens"];
            subCategoryData = [self subCategory:indexPath.row];
            self.cid = [[[subCategoryData objectAtIndex:indexPath.item] objectForKey:@"cid"] integerValue];

            [self refreshingData:1 callback:^{}];
        }

    }
    else if(indexPath.column == 2){
        
        self.o = [[filterData objectAtIndex:indexPath.row] objectForKey:@"o"];
        self.ot = [[[filterData objectAtIndex:indexPath.row] objectForKey:@"ot"] integerValue];
        
        [self refreshingData:1 callback:^{}];
    }
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

- (NSArray *) subCategory:(NSInteger) row
{
    NSMutableArray *category = [[NSMutableArray alloc] init];
    NSArray *pCategory = [[categoryData objectAtIndex:row] objectForKey:@"childrens"];
    NSLog(@"-!!!!--%@",categoryData);
    
    for (NSInteger i=0;i<pCategory.count;i++){
        NSArray *childs = [[pCategory objectAtIndex:i] objectForKey:@"childrens"];
        
        
        if([childs count]>0){
            
            for(NSInteger j=0;j<childs.count;j++){
                [category addObject:childs[j]];
            }
        }else{
            [category addObject:pCategory[i]];
        }
    }
    return category;
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
