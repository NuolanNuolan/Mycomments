//
//  CommentViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import "CommentViewController.h"
#import "CommentMainTableViewFrame.h"
#import "CommentMainTableViewCell.h"
#import "ShopDetailViewController.h"
#import "MemberTableViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface CommentViewController ()

@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;
@property(nonatomic, assign) NSString *cusername;

@end

@implementation CommentViewController

@synthesize dataArray;
-(void)viewWillAppear:(BOOL)animated
{

//    [self refreshingData:self.gpage callback:^{}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagelayout];
    [self refreshingData:self.gpage callback:^{}];
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
    self.navigationItem.title = @"Latest Comments";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator=NO;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    

    self.gpage = 1;
//    [self refreshingData:self.gpage callback:^{}];
    
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


-(void) memberTouched:(UIButton *) sender{
    
    NSDictionary *data = [dataArray objectAtIndex:sender.tag];
    
    MYLOG(@"member log: %ld",sender.tag);
    
    MemberTableViewController *viewController = [[MemberTableViewController alloc] init];
    self.memberDelegate = viewController;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.memberDelegate setValue:[data objectForKey:@"username"]];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeCustomView;
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:self.myComments ? @"MyComments" : @"Comments"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    if(self.myComments){
        if(self.cusername){
            [postData setValue:self.cusername forKey:@"username"];
            //是自己的评论
            if ([self.cusername isEqualToString:[BWCommon getUserInfo:@"username"]]) {
                _ismyComments = YES;
            }
        }else{
            [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
        }
    }
    //[postData setValue:[NSString stringWithFormat:@"%@",self.OrderInfo_sort] forKey:@"OrderInfo_sort"];
    
    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            NSMutableDictionary *data = [responseObject objectForKey:self.myComments?@"msg":@"data"];
            
            
            if(page == 1)
            {
                dataArray = [[data objectForKey:@"lists"] mutableCopy];
            }
            else
            {
                [dataArray addObjectsFromArray:[[data objectForKey:@"lists"] mutableCopy]];
                
            }
            
            MYLOG(@"%@",dataArray);
            
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
            MYLOG(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        MYLOG(@"请求失败");
    }];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentMainTableViewFrame *vf = self.statusFrames[indexPath.row];
    
    return vf.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentMainTableViewCell *cell = [CommentMainTableViewCell cellWithTableView:tableView];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    cell.memberButton.tag = indexPath.row;
    cell.hasName = YES;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [cell.likeButton addTarget:self action:@selector(likeTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.memberButton addTarget:self action:@selector(memberTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.myComments){
        [cell.likeButton setHidden:YES];
    }
    
//    [cell.removeButton addTarget:self action:@selector(removeTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
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
///** TableView 进入或退出编辑状态(TableView 方法). */
//- (void)setEditing:(BOOL)editing animated:(BOOL)animate
//{
//
//    
//}
//
/** 确定哪些行的cell可以编辑 (UITableViewDataSource协议中方法). */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_ismyComments) {
        return YES;
    }else
    {
        if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"username"]isEqualToString:[BWCommon getUserInfo:@"username"]]) {
            return YES;
        }


    }
//    MYLOG(@"%@",dataArray);
    return NO;
}
//
/** 设置某一行cell的编辑模式 (UITableViewDelegate协议中方法). */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Delete";

    
}
//
///** 提交编辑状态 (UITableViewDataSource协议中方法). */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(editingStyle==UITableViewCellEditingStyleDelete)
        
    {
    
        MYLOG(@"删除");
        [self removeTouched:indexPath.row];
    }
}
//
///** 插入 cell (UITableView 方法). */
//- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
//
///** 删除 cell (UITableView 方法). */
//- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation



-(void) removeTouched:(NSInteger ) cid{
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        //__weak CommentViewController *weakSelf = self;
        
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            //[weakSelf.tableView reloadData];
        }];
        
        return;
    }
    
    
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"System Tips" message:@"Delete confirm?" preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
                                 {
                                     [self deleteCommentPost:cid];
                                 }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void) deleteCommentPost:(NSInteger) cid{
    
    //cid是indexpath.row
    NSInteger sid = [[[dataArray objectAtIndex:cid] objectForKey:@"id"] integerValue];
//    NSInteger uid = [[[dataArray objectAtIndex:cid] objectForKey:@"uid"] integerValue];
//        MYLOG(@"cid是%ld,uid是%ld",(long)sid,(long)uid);
    [HttpEngine DeleteComments:[BWCommon getUserInfo:@"username"] withcid:sid complete:^(NSString *issucc) {
        if ([issucc isEqualToString:@"succ"]) {
            [MBProgressHUD showSuccess:@"delete success"];
            [dataArray removeObjectAtIndex:cid];
            [self.tableView reloadData];
        }else
        {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"System Tips" message:issucc preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
    

}

-(void) likeTouched:(UIButton *) sender{
    MYLOG(@"%ld",sender.tag);
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        //__weak CommentViewController *weakSelf = self;
        
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            //[weakSelf.tableView reloadData];
        }];
        
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *username = [BWCommon getUserInfo:@"username"];
    NSInteger cid = sender.tag;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"likeIt"];
    [AFNetworkTool postJSONWithUrl:url parameters:@{@"username":username,@"id":[NSString stringWithFormat:@"%ld",cid]} success:^(id responseObject) {
        
        MYLOG(@"%@",responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            [sender setTitle:[NSString stringWithFormat:@"(%@)",[responseObject objectForKey:@"data"]] forState:UIControlStateNormal];
        }
        else
        {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:[responseObject objectForKey:@"data"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
            MYLOG(@"%@",[responseObject objectForKey:@"data"]);
        }
    } fail:^{
        [hud removeFromSuperview];
    }];

    
}

- (NSArray *)statusFrames
{
//    if (_statusFrames == nil) {
    
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            CommentMainTableViewFrame *vf = [[CommentMainTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        _statusFrames = [models copy];
//    }
    
    return _statusFrames;
}

-(void) setValue:(NSString *)usernameValue{
    self.cusername = usernameValue;
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
