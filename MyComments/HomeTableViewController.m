//
//  HomeTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import "HomeTableViewController.h"
#import "BWCommon.h"
#import "CommentTableViewCell.h"
#import "CommentTableViewFrame.h"
#import "ShopViewController.h"
#import "ShopDetailViewController.h"
#import "RegionTableViewController.h"
//#import "SearchResultsViewController.h"
#import "MemberTableViewController.h"
#import "HomeMapViewController.h"
#import "BWSectionView.h"
#import "AFNetworkTool.h"

@interface HomeTableViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;
@property (nonatomic,strong) NSArray *regions;
@property (nonatomic,strong) UIBarButtonItem *cityItem;
@property (nonatomic,strong) UIButton *cityItemButton;
@property (nonatomic,strong) NSString *region_id;

//searchResult
//@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation HomeTableViewController

@synthesize dataArray;
@synthesize popularCityArray;

CGSize size;

NSString *trackViewURL;
-(void)viewWillAppear:(BOOL)animated
{

    MYLOG(@"我是重新刷新页面");
    NSString *city_name = [BWCommon getUserInfo:@"region_name"];
    if(city_name)
    {
        if ([city_name length] > 13)
          city_name =[NSString stringWithFormat:@"%@...",[city_name substringToIndex:13]];
        [self.cityItemButton setTitle:city_name forState:UIControlStateNormal];
    }else
    {
    
        [self.cityItemButton setTitle:@"All" forState:UIControlStateNormal];
    }
    //这里是判断他有没有切换城市 如果切换了
    NSString *reshregion_id =[BWCommon getUserInfo:@"region_id"];
    if (reshregion_id) {
        if (![reshregion_id isEqualToString:self.region_id]) {
            self.gpage = 1;
            self.region_id = reshregion_id;
        }
    }else
    {
    
        self.region_id = @"20";
    }
    
    MYLOG(@"我刷新了一次我的region_id%@",self.region_id);
    
//    self.gpage = 1;
    
    [self refreshingData:self.gpage callback:^{}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
    //城市数组
    self.regions = [[NSArray alloc]init];
    //注册监听通知
    [self NotifationTableview];
    //self.region_id = @"20";
    
    [self pageLayout];

}
-(void)NotifationTableview
{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TableviewReloaddata:)
                                                 name:@"Popular_cityNotification"
                                               object: nil];
}
//等到数据处理才去加载数据刷新表格
-(void)TableviewReloaddata:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"Success"])
    {
        
        popularCityArray = [BWCommon getDataInfo:@"popular_city"];
        [self.tableView reloadData];
        
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.manager.distanceFilter = 5.0f;
        
        if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.manager requestWhenInUseAuthorization];
            
        }
        if([CLLocationManager locationServicesEnabled]){
            [self.manager startUpdatingLocation];
        }else{
            MYLOG(@"Please enable location service.");
        }

    }
    else
    {
        
        self.regions = [BWCommon getUserInfo:@"regions"];
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.manager.distanceFilter = 5.0f;
        
        if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.manager requestWhenInUseAuthorization];
            
        }
        if([CLLocationManager locationServicesEnabled]){
            [self.manager startUpdatingLocation];
        }else{
            MYLOG(@"Please enable location service.");
        }

    }
    MYLOG(@"刷新了一次表格");
}

-(void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_map"] style:UIBarButtonItemStylePlain target:self action:@selector(mapTouched:)];
    
    self.navigationItem.rightBarButtonItem = mapItem;
    
    
    
    //cityButton
    self.cityItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.cityItemButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.cityItemButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.cityItemButton.titleLabel.lineBreakMode = 0;
    
    //UIImage *arrowIcon = [UIImage imageNamed:@"navbar_arrow"];
    //UIImageView *arrowIconView = [[UIImageView alloc] initWithImage:arrowIcon];
    
    //[cityButton addSubview:arrowIconView];
    
    
    //self.cityItem = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(regionTouched:)];
    

    //self.cityItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityItemButton];
    
    //[cityButton.titleLabel setText:@"All"];
    [self.cityItemButton setTitle:@"All" forState:UIControlStateNormal];
    [self.cityItemButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    
    [self.cityItemButton addTarget:self action:@selector(regionTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    //[leftItem setTitle:@"All"];
    //[leftItem setImage:arrowIcon];
    //[self.cityItem setTintColor:[UIColor whiteColor]];
    //[self.cityItem setTitleTextAttributes:[NSDictionary
      //      dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName,nil] forState:UIControlStateNormal];

    [self.navigationItem setTitleView:self.cityItemButton];
    
    /*UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,size.width-140,30)];
    searchBar.tag = 10001;
    searchBar.delegate = self;
    searchBar.placeholder = @"Search for shop name";
    */
    //[self.view addSubview:searchBar];
   // [middleView addSubview:searchButton];
    
    
   // [self.navigationItem setTitleView:middleView];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;

    popularCityArray = [BWCommon getDataInfo:@"popular_city"];
    
//    MYLOG(@"popular City Array:%@",popularCityArray);
    self.gpage = 1;
    
    //[self refreshingData:self.gpage callback:^{}];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];

    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"Loading ..." forState:MJRefreshFooterStateRefreshing];
    [self.tableView.footer setTitle:@"No more merchants." forState:MJRefreshFooterStateNoMoreData];
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
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        
        return;
    }else{
        
        self.regions = [BWCommon getUserInfo:@"regions"];
        
//        MYLOG(@"regions:%@",self.regions);
        NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
        
        //NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",3.16,101.7];
        
        [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
            
            //NSDictionary *dict = [NSDictionary alloc]
            NSArray *results = [json objectForKey:@"results"];
            
            if([results count] <=0)
                return;
            
            NSArray *address_components = [results[0] objectForKey:@"address_components"];
            
            //MYLOG(@"address_components: %@",address_components);
            
            for(NSInteger i=0;i<[address_components count];i++){
                NSDictionary *address=[address_components objectAtIndex:i];
                //判断是否是真正实体名称
                if([address[@"types"][0] isEqual: @"locality"]){
                    NSString * long_name=address[@"long_name"];
                    
                    //MYLOG(@"long name:%@",long_name);
                    
                    //查询是否存在此地区
                    for(int j=0;j<[self.regions count];j++){
                        
                        if([self.regions[j][@"region_name"] isEqualToString: long_name]){
                            //当前城市
                            //Ti.App.Properties.setString('city',long_name);
                            //Ti.App.Properties.setString('city_id',list[j].region_id);
                            
                            //loadLastedComments(1,list[j].region_id);
                            //refreshCity();
                            //return true;
                            
                            [BWCommon setUserInfo:@"region_name" value:long_name];
                            [BWCommon setUserInfo:@"gps_region_name" value:long_name];
                            [BWCommon setUserInfo:@"region_id" value:self.regions[j][@"region_id"]];
                            self.region_id =self.regions[j][@"region_id"];
                            [BWCommon setUserInfo:@"gps_region_id" value:self.regions[j][@"region_id"]];
                            
                            MYLOG(@"GPS:%@",long_name);
                            
                            [self.cityItemButton setTitle:long_name forState:UIControlStateNormal];
                            [self refreshingData:1 callback:nil];
                            [self.manager stopUpdatingLocation];
                            return;
                        }
                    }
                    //Ti.API.info(i);
                }
            }
            //MYLOG(@"%@",results);
        } fail:^{
            
        }];
        
        MYLOG(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    }
    // 停止位置更新
    [self.manager stopUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    MYLOG(@"%@",error);
    if ([error code] == kCLErrorDenied) {
        //        CLog(@"访问被拒绝");
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"Please enable location service."];
    }
    if ([error code] == kCLErrorLocationUnknown) {
//        CLog(@"无法获取位置信息");
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"Unable to get the location."];
    }
}
- (void) mapTouched:(id) sender{
    HomeMapViewController *mapView = [[HomeMapViewController alloc] init];
    mapView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:mapView animated:YES];
}

- (void) headerRefreshing{
    
    self.gpage = 1;
    @weakify(self);
    
    [self refreshingData:self.gpage callback:^{
         @strongify(self);
        [self.tableView.header endRefreshing];
    }];
    
}
- (void )footerRereshing{
//    @weakify(self);
//    [self refreshingData:++self.gpage callback:^{
//        @strongify(self);
////        [self.tableView.footer endRefreshing];
//    }];
    
    [self refreshingData:++self.gpage callback:nil];
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    //hud = [BWCommon getHUD];
    //hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"LatestComments"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [postData setValue:self.region_id forKey:@"region_id"];
   

    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        //[hud removeFromSuperview];
        if(code == 200)
        {
            
            //MYLOG(@"kkkkkk%@",[responseObject objectForKey:@"data"]);
            
            
            if([responseObject objectForKey:@"data"])
            {

                NSMutableDictionary *data = [responseObject objectForKey:@"data"];
                
            if(page == 1)
            {
                dataArray = [ [data objectForKey:@"lists"] mutableCopy];
            }
            else
            {
                NSArray *FootArr_Load =[[data objectForKey:@"lists"] mutableCopy];
                
                if (FootArr_Load.count==0) {
                    
                   [self.tableView.footer noticeNoMoreData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.tableView.footer resetNoMoreData];
                    });
                   
                    
                }else{
                
                    [dataArray addObjectsFromArray:FootArr_Load];
                    [self.tableView.footer endRefreshing];
                }

                
            }
            }
            if (dataArray.count==0) {
                [self.tableView.footer noticeNoMoreData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView.footer resetNoMoreData];
                });
            }
            self.statusFrames = nil;
            
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            
            if(callback){
                callback();
            }
            
            //MYLOG(@"%@",json);
        }
        else
        {
            MYLOG(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        //[hud removeFromSuperview];
        MYLOG(@"请求失败");
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if(section == 0)
        return 1;
    else if(section == 1)
        return 1;
    else if(section == 2)
        return [dataArray count];
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return  0;

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        NSInteger swidth = (size.width *0.6)/3;
        return swidth + 40;
    }
    else if(indexPath.section == 1){
        return 120;
    }
    else if(indexPath.section == 2){
        CommentTableViewFrame *vf = self.statusFrames[indexPath.row];

        return vf.cellHeight;
    }
    
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 2)
    {
        CommentTableViewCell * cell = [CommentTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.statusFrames[indexPath.row];
        cell.memberButton.tag = indexPath.row;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [cell.memberButton addTarget:self action:@selector(memberTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    
    }
    else{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section==0){
        NSInteger swidth = (size.width *0.6)/3;
        NSInteger spadding = (size.width *0.4)/4;
        UIButton *restaurant = [self createButton:self Selector:@selector(categoryTouched:) Image:@"home_restaurant_icon.png" Title:@"Restaurant"];
        restaurant.frame = CGRectMake(spadding, 10, swidth, swidth);
        restaurant.tag = 2;
        [cell addSubview:restaurant];
        UIButton *lifestyle = [self createButton:self Selector:@selector(categoryTouched:) Image:@"home_life_style_icon.png" Title:@"Life&Style"];
        lifestyle.tag = 3;
        lifestyle.frame = CGRectMake(spadding*2 + swidth, 10, swidth, swidth);
        [cell addSubview:lifestyle];
        UIButton *travel = [self createButton:self Selector:@selector(categoryTouched:) Image:@"home_travel_icon.png" Title:@"Travel"];
        travel.tag = 4;
        travel.frame = CGRectMake(spadding*3 + swidth*2, 10, swidth, swidth);
        [cell addSubview:travel];
    }
    else if(indexPath.section == 1){
        
        CGFloat bx=8;
        CGFloat by=8;
        for (int i=0;i<[popularCityArray count];i++){
            
            NSString *title = [popularCityArray[i] objectForKey:@"region_name"];
            UIButton *b1 = [self createCityButton:self Selector:@selector(cityTouched:) Title:title];
            //b1.tag = [[popularCityArray[i] objectForKey:@"region_id"] integerValue];
            CGSize bsize = [BWCommon sizeWithString:title font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(160,MAXFLOAT)];
            CGFloat bwidth = bsize.width + 18;
            if(bx+ bwidth > size.width){
                by += 34;
                bx = 8;
            }
            
            b1.tag = [[popularCityArray[i] objectForKey:@"region_id"] integerValue];
            b1.frame = CGRectMake(bx, by, bwidth, 35);
            UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"dot"]];
            dot.frame = CGRectMake(bwidth-5, 30, 4, 4);
            [b1 addSubview:dot];
            
            bx += bwidth-1;
            [cell addSubview:b1];
            
        }
    }
        
        return cell;
    }
    
    

}

-(void) memberTouched:(UIButton *) sender{
    
    NSDictionary *data = [dataArray objectAtIndex:sender.tag];
    
    MYLOG(@"member log: %ld",sender.tag);
    
    MemberTableViewController *viewController = [[MemberTableViewController alloc] init];
    self.memberDelegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.memberDelegate setValue:[data objectForKey:@"username"]];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void) categoryTouched:(UIButton *)sender{
    
    ShopViewController *viewController = [[ShopViewController alloc] init];
    self.delegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    
    NSString *cat_name = @"";
    if(sender.tag == 1){
        cat_name = @"Restaurant";
    }
    else if(sender.tag == 2){
        cat_name = @"Life & Style";
    }
    else if(sender.tag == 3){
        cat_name = @"Travel";
    }
    //clear old region id
    [BWCommon setUserInfo:@"" value:@"parent_region_id"];

    [self.delegate setValue:0 cid:sender.tag region_name:@"" cat_name:sender.titleLabel.text];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void) cityTouched:(UIButton *)sender{
    
    for (int i=0;i<[popularCityArray count];i++){
        if([popularCityArray[i][@"region_id"] integerValue] == sender.tag)
        {
            [BWCommon setUserInfo:@"parent_region_id" value:popularCityArray[i][@"parent_id"]];
            break;
        }
    }
    ShopViewController *viewController = [[ShopViewController alloc] init];
    self.delegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    
    //MYLOG(@"sender title%@",sender.currentTitle);
    [self.delegate setValue:sender.tag cid:0 region_name:sender.currentTitle cat_name:@""];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void) regionTouched:(UIBarButtonItem *)sender{
    RegionTableViewController *viewController = [[RegionTableViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIButton*) createButton:(id)target Selector:(SEL)selector Image:(NSString *)image Title:(NSString *) title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];

    UIImage *newImage = [UIImage imageNamed: image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:12.0];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *) createCityButton:(id)target Selector:(SEL)selector Title:(NSString *) title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:12.0];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [BWCommon getBorderColor].CGColor;
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    


    BWSectionView *headView = [[BWSectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, 30)];
    
    headView.tableView = tableView;
    headView.section = section;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 200, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:titleLabel];
    
    if(section == 1){
        titleLabel.text = @"Popular City";
    }
    else if(section == 2){
        titleLabel.text = @"Latest Comments";
    }
    
    return headView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:indexPath.section>1 ? YES : NO];
    
    if(indexPath.section > 1){
        ShopDetailViewController *viewController = [[ShopDetailViewController alloc] init];
        self.detailDelegate = viewController;
        viewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        NSInteger sid = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"sid"] integerValue];
        [self.detailDelegate setValue:sid];
    }
}


- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            CommentTableViewFrame *vf = [[CommentTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
