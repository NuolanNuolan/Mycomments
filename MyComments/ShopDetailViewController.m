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
#import "CommentMainTableViewCell.h"
#import "CommentMainTableViewFrame.h"
#import "BWSectionView.h"
#import "AFNetworkTool.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


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

CGSize addressSize;
CGSize detailSize;
CGSize tagSize;

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagelayout];
}

- (void) pagelayout{
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = @"";
    
    //self.hidesBottomBarWhenPushed = YES;
    
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
    
    [tableView setHidden:YES];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];

    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    //[self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    
    [self refreshingData:self.sid callback:^{}];
    
    //右侧按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *collectionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_collection.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    NSArray *barItems = [[NSArray alloc] initWithObjects:shareButton,collectionButton, nil];
    [self.navigationItem setRightBarButtonItems:barItems];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if(section < 5)
        return 1;
    else if (section == 5)
        return [dataArray count];

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
    
    
    BWSectionView *view = [[BWSectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, 36)];
    
    view.tableView = tableView;
    view.section = section;
    
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
        addressSize = [BWCommon sizeWithString:[[shopDict objectForKey:@"shop"] objectForKey:@"address"] font:NJNameFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
        return MAX(30,addressSize.height + 20);
    }
    else if(indexPath.section == 4)
    {
        //计算cell高度
        detailSize = [BWCommon sizeWithString:[[shopDict objectForKey:@"shop"] objectForKey:@"opening_hours"] font:NJNameFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
        tagSize = [BWCommon sizeWithString:[[shopDict objectForKey:@"shop"] objectForKey:@"tags"] font:NJTextFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
        return detailSize.height + 20 + tagSize.height + 30;
    }
    else if (indexPath.section == 5){
        
        CommentMainTableViewFrame *vf = self.statusFrames[indexPath.row];
        return vf.cellHeight;
        
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        ShopMainTableViewCell *cell = [ShopMainTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.shopFrames[0];
        return cell;
    }
    
    if(indexPath.section == 5) {
        CommentMainTableViewCell *cell = [CommentMainTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.statusFrames[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = NJNameFont;
    
    //address
    if(indexPath.section == 1){
        cell.textLabel.text = [[shopDict objectForKey:@"shop"] objectForKey:@"address"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = [[shopDict objectForKey:@"shop"] objectForKey:@"tel"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 3) {
        cell.textLabel.text = [[shopDict objectForKey:@"shop"] objectForKey:@"website"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 4) {
        
        UILabel *detailLabel = [[UILabel alloc] init];
        
        detailLabel.font = NJNameFont;
        detailLabel.text = [[shopDict objectForKey:@"shop"] objectForKey:@"opening_hours"];
        detailLabel.frame = CGRectMake(10, 10, detailSize.width, detailSize.height);
        [cell.contentView addSubview:detailLabel];
        
        NSArray *tags =[[shopDict objectForKey:@"shop"] objectForKey:@"tags_all"];
        
        CGFloat y = detailSize.height+ 20;
        CGFloat x = 10;
        for(NSDictionary *dict in tags){
            NSString *name = [dict objectForKey:@"name"];
            CGSize nameSize = [BWCommon sizeWithString:name font:NJNameFont maxSize:CGSizeMake(200, MAXFLOAT)];
            CGFloat bwidth = nameSize.width + 12;
            if(x+ bwidth > size.width){
                y += 21;
                x = 10;
            }

            UIButton *tagButton = [[UIButton alloc] init];
            [tagButton setTitle:name forState:UIControlStateNormal];
            tagButton.titleLabel.font = NJTextFont;
            [tagButton setBackgroundColor:[BWCommon getRedColor]];
            [tagButton setTitleColor:[BWCommon getRGBColor:0xffffff] forState:UIControlStateNormal];
            tagButton.frame = CGRectMake(x, y, bwidth, 20);
            
            x += bwidth + 2;
            [cell.contentView addSubview:tagButton];
        }
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

            
            dataArray = [[[shopDict objectForKey:@"comments"] objectForKey:@"lists"] mutableCopy];
            
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

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            CommentMainTableViewFrame *vf = [[CommentMainTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
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
