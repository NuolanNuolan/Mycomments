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
#import "AddMerchantViewController.h"

@interface ShopViewController ()

@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic, assign) BOOL isone;
@property (nonatomic,assign) NSInteger region_id;
@property (nonatomic,assign) NSInteger cid;
@property (nonatomic,assign) NSInteger gpage;
@property (nonatomic,assign) NSString *o;
@property (nonatomic,assign) NSInteger ot;

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

CLLocation *_location;

BOOL has_data;

CGSize size;

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
    size = rect.size;
    self.isone =YES;
    has_data = YES;
    
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
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.manager.distanceFilter = 5.0f;
    
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
        
    }
    if([CLLocationManager locationServicesEnabled]){
        [self.manager startUpdatingLocation];
    }else{
        MYLOG(@"Please enable location service.");
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, size.width, size.height-42)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    //[BWCommon setUserInfo:@"parent_region_id" value:[drow objectForKey:@"parent_id" ]];
    NSInteger parent_region_id = [[BWCommon getUserInfo:@"parent_region_id"] integerValue];
    //init data
    [BWCommon setUserInfo:@"" value:@"parent_region_id"];
    
    MYLOG(@"parent_region_id: %ld",parent_region_id);
    
    if(parent_region_id<=0){
        parent_region_id = 1;
    }
    
    
    provinceData = [BWCommon loadRegions:parent_region_id initData:@"Location"];
    categoryData = [BWCommon getDataInfo:@"category"];
    
    //MYLOG(@"%@",categoryData);
    
    //Default, Rate Descending , Rate Ascending, Price Ascending, Price Descending,Nearest
    
    filterData = [[NSMutableArray alloc] initWithCapacity:6];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Default",@"name",@"",@"o",@"0",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Rate Descending",@"name",@"rate",@"o",@"2",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Rate Ascending",@"name",@"rate",@"o",@"1",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Price Ascending",@"name",@"price",@"o",@"1",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Price Descending",@"name",@"price",@"o",@"2",@"ot", nil]];
    [filterData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Nearest",@"name",@"nearest",@"o",@"2",@"ot", nil]];
    
    //MYLOG(@"%@",filterData);
    
    
    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    [self.menu setSeparatorColor:[UIColor whiteColor]];
    //self.menu.indicatorColor = [BWCommon getMainColor];
    //self.menu.textSelectedColor = [BWCommon getMainColor];
    //self.menu.textColor = [BWCommon getMainColor];
    
    self.menu.delegate = self;
    self.menu.dataSource = self;
    
    //self.menu.remainMenuTitle = YES;
    
    
    [self.view addSubview:self.menu];
    
    [self selectDefaultMenu];
    
    
    //初始化
    self.o = @"";
    self.ot = 0;
    
    self.gpage = 1;
//    [self refreshingData:self.gpage callback:^{}];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"Loading ..." forState:MJRefreshFooterStateRefreshing];
    [self.tableView.footer setTitle:@"No more merchants." forState:MJRefreshFooterStateNoMoreData];
    
}


-(void) selectDefaultMenu{
    
    if(self.region_id)
    {
        for(int i=0;i<[provinceData count];i++){
            if( [provinceData[i][@"region_id"] integerValue] == self.region_id )
            {
                DOPIndexPath *indexPath = [DOPIndexPath indexPathWithCol:0 row:i];
                [self.menu selectIndexPath:indexPath];
                break;
            }
        }
    }
    
    if(self.cid)
    {
        for(int i=0;i<[categoryData count];i++){
            if( [categoryData[i][@"cid"] integerValue] == self.cid )
            {
                DOPIndexPath *indexPath = [DOPIndexPath indexPathWithCol:1 row:i];
                [self.menu selectIndexPath:indexPath];
                break;
            }
        }
    }
    
    if(![self.region_name isEqualToString:@""]){
        [self.navigationItem setTitle:self.region_name];
    }
    else{
        NSString *region_name = [BWCommon getUserInfo:@"region_name"];
        if(region_name)
        {
            [self.navigationItem setTitle:region_name];
        }
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1)
    {
        oldLocation = [locations objectAtIndex:locations.count-2];
    }
    else
    {
        oldLocation = nil;
    }
    
    _location = newLocation;
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 1.0){//如果调用已经一次，不再执行

        return;
    }else{
    
        MYLOG(@"我执行了几次?");
        [self refreshingData:self.gpage callback:^{}];
    }
    
    MYLOG(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    // 停止位置更新
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    MYLOG(@"%@",error);
}

- (void) headerRefreshing{
    @weakify(self);
    self.gpage = 1;
    [self refreshingData:self.gpage callback:^{
        @strongify(self);
        [self.tableView.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    
//    [self refreshingData:++self.gpage callback:^{
//        [self.tableView.footer endRefreshing];
//    }];
    [self refreshingData:++self.gpage callback:nil];
}


- (void) setValue:(NSUInteger)region_id cid:(NSUInteger)cid region_name:(NSString *)region_name cat_name:(NSString *)cat_name{
    
    
    self.cid = cid;
    self.region_name = region_name;
    self.cat_name = cat_name;
    
    if(region_id<=0){
        region_id = [[BWCommon getUserInfo:@"region_id"] integerValue];
    }
    
    self.region_id = region_id;
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    //hud.mode = MBProgressHUDModeCustomView;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"search"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.region_id] forKey:@"region_id"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.cid] forKey:@"cid"];
    [postData setValue:self.o forKey:@"o"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.ot] forKey:@"ot"];
    
    [postData setValue:[NSString stringWithFormat:@"%f",_location.coordinate.longitude] forKey:@"lng"];
    [postData setValue:[NSString stringWithFormat:@"%f",_location.coordinate.latitude] forKey:@"lat"];
    
    MYLOG(@"这是我要上传的数据%@",postData);
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
//                [dataArray addObjectsFromArray:[[data objectForKey:@"lists"] mutableCopy]];
                NSArray *FootArr_Load =[[data objectForKey:@"lists"] mutableCopy];
                
                if (FootArr_Load.count==0) {
                    
                    [self.tableView.footer noticeNoMoreData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.tableView.footer resetNoMoreData];
                    });
                    
                }else{
                    
                    [dataArray addObjectsFromArray:FootArr_Load];
                    if ([self.o isEqualToString:@"nearest"]) {
                        //对距离进行排序
                        [self OrderbyDistance:dataArray];
                    }
                    [self.tableView.footer endRefreshing];
                }
                
            }
            
            has_data = [dataArray count] > 0  || page >1 ? YES : NO;
            
            MYLOG(@"%@",dataArray);
            
//            self.tableView.footer.hidden = (dataArray.count <=0) ? YES : NO;
            
            self.statusFrames = nil;
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            
            
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataArray.count<1) {
        return;
    }
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
        return [categoryData count] + 5;
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
        //MYLOG(@"titleForRowAtIndexPath %ld",(long)[indexPath row]);
        if ([indexPath row] >=[categoryData count] ) {
            return @"";
        }
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
        
        cityData = [BWCommon loadRegions:parent_id initData:@"All"];
        MYLOG(@"%@",cityData);
        return [cityData count];
    }
    else if(column == 1){
        MYLOG(@"numberOfItemsInRow %ld",(long)row);
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
        
        cityData = [BWCommon loadRegions:parent_id initData:@"All"];
        
        return [[cityData objectAtIndex:indexPath.item] objectForKey:@"region_name"];
        
    }
    else if(indexPath.column == 1){
        //subCategoryData = [[categoryData objectAtIndex:indexPath.row] objectForKey:@"childrens"];
        subCategoryData = [self subCategory:indexPath.row];
        MYLOG(@"title For Items %@",subCategoryData);
        return [[subCategoryData objectAtIndex:indexPath.item] objectForKey:@"cat_name"];
    }
    return nil;
    
}

-(NSString *) menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    return @"";
}


-(void) menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (self.isone) {
        self.isone=NO;
        return;
    }
    if(indexPath.column == 0){
        
        MYLOG(@"item %ld",indexPath.item);
        MYLOG(@"row %ld",indexPath.row);
        
        if (indexPath.item >= 0){
            NSUInteger parent_id =[[[provinceData objectAtIndex:indexPath.row] objectForKey:@"region_id"]
                                   integerValue];
            cityData = [BWCommon loadRegions:parent_id initData:@"All"];
            
            if(indexPath.item == 0){
                self.region_id = parent_id;
                DOPIndexPath *dopIndexPath = [DOPIndexPath indexPathWithCol:0 row:indexPath.row];
                //[menu titleForRowAtIndexPath:dopIndexPath];
                [menu selectIndexPath:dopIndexPath];
            }else{
                self.region_id = [[[cityData objectAtIndex:indexPath.item] objectForKey:@"region_id"] integerValue];
                [self refreshingData:1 callback:^{}];
            }

        }else if (indexPath.item==-1){
            NSUInteger parent_id =[[[provinceData objectAtIndex:indexPath.row] objectForKey:@"region_id"]
                                   integerValue];
                self.region_id = parent_id;
                [self refreshingData:1 callback:^{}];
            
        }
    }
    else if (indexPath.column == 1){
        MYLOG(@"item2 %ld",indexPath.item);
        MYLOG(@"row2 %ld",indexPath.row);
        if (indexPath.item >= 0){
            
            //subCategoryData = [[categoryData objectAtIndex:indexPath.row] objectForKey:@"childrens"];
            subCategoryData = [self subCategory:indexPath.row];
            //MYLOG(@"subCategoryData %@",subCategoryData);
            //MYLOG(@"item %ld",indexPath.item);
            //MYLOG(@"row %ld",indexPath.row);
            MYLOG(@"%@",[subCategoryData objectAtIndex:indexPath.item]);
            self.cid = [[[subCategoryData objectAtIndex:indexPath.item] objectForKey:@"cid"] integerValue];
            MYLOG(@"这是我的这是我的这是我的这是我的这是我的这是我的这是我的这是我的cid%ld",(long)self.cid);
            [self refreshingData:1 callback:^{}];
        }
        
    }
    else if(indexPath.column == 2){
        MYLOG(@"第三个菜单栏%ld",(long)indexPath.row);
        self.o = [[filterData objectAtIndex:indexPath.row] objectForKey:@"o"];
        self.ot = [[[filterData objectAtIndex:indexPath.row] objectForKey:@"ot"] integerValue];
        
        [self refreshingData:1 callback:^{}];
    }
}

- (NSIndexPath *)menu:(DOPDropDownMenu *)menu willSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if(indexPath.column == 1){
        
        //MYLOG(@"indexPath: row:%ld item: %ld",(long)indexPath.row,(long)indexPath.item);
        //if(indexPath.row >= [categoryData count] && indexPath.item<=0)
        //    return nil;
        
    }
    NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.column];
    return ip;
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
    
    if (!has_data)
        return 1;
    
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!has_data)
        return 100;
    
    ShopTableViewFrame *vf = self.statusFrames[indexPath.row];
    
    return vf.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellNone";
    
    if (!has_data)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            //[cell.textLabel setText:@"No result found"];
            //[cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            //[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            
            UILabel *noResult = [[UILabel alloc] initWithFrame:CGRectMake((size.width - 240)/2, 30, 120, 20)];
            [noResult setText:@"No result found"];
            [noResult setFont:[UIFont systemFontOfSize:14]];
            [noResult setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:noResult];
            
            UIButton *addMerchant = [[UIButton alloc] initWithFrame:CGRectMake((size.width - 240)/2+120, 30, 120, 20)];
            [addMerchant setTitle:@"Add Merchant >>" forState:UIControlStateNormal];
            [addMerchant setTitleColor:[BWCommon getRedColor] forState:UIControlStateNormal];
            //[addMerchant.layer setCornerRadius:5.0f];
            [addMerchant.titleLabel setFont:[UIFont systemFontOfSize:14]];
            //[addMerchant.layer setBorderWidth:1.0f];
            //[addMerchant.layer setBorderColor:[BWCommon getRedColor].CGColor];
            [cell.contentView addSubview:addMerchant];
            [addMerchant addTarget:self action:@selector(addMerchantTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        return cell;
    }
    
    ShopTableViewCell *cell = [ShopTableViewCell cellWithTableView:tableView];
    
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}
//对请求回来的数组进行距离排序
-(void)OrderbyDistance:(NSMutableArray *)array
{
    //这里类似KVO的读取属性的方法，直接从字符串读取对象属性，注意不要写错
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    //这个数组保存的是排序好的对象
    NSArray *tempArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    dataArray = [NSMutableArray arrayWithArray:tempArray];
}
-(void) addMerchantTouched: (UIButton *)sender{
    
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        __weak ShopViewController *weakSelf = self;
        
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            [weakSelf.tableView reloadData];
        }];
        
        return;
    }
    
    AddMerchantViewController *viewController = [[AddMerchantViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (NSArray *) subCategory:(NSInteger) row
{
    NSMutableArray *category = [[NSMutableArray alloc] init];
    
    if(row >= [categoryData count])
        row = 0;
    
    NSDictionary *pObj = [categoryData objectAtIndex:row];
    [category addObject:pObj];
    
    NSArray *pCategory = [[categoryData objectAtIndex:row] objectForKey:@"childrens"];
    //MYLOG(@"-!!!!--%@",categoryData);
    
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
