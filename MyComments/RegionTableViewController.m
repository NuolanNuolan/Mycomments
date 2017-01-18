//
//  RegionTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-9-9.
//
//

#import "RegionTableViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface RegionTableViewController ()<UIScrollViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate>
{

    //定义一个不变的数组 来保存原始数据
    NSArray *TheSameArr;
}
@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation RegionTableViewController
@synthesize dataArray;
CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pageLayout];
}

- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.navigationItem.title = @"Location";
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
    _searchBar.delegate=self;
    [self.tableView setTableHeaderView:_searchBar];
    
    //searchBar.text = @"Search";
    //searchBar add
    
    [self refreshingData:^{}];
}


- (void) refreshingData:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"citylistbyprovince"];

    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            dataArray = [[responseObject objectForKey:@"data"] mutableCopy];
            
            //
            
            NSString *gps_region_name = [BWCommon getUserInfo:@"gps_region_name"];
            NSString *gps_region_id = [BWCommon getUserInfo:@"gps_region_id"];
            
            if(![gps_region_name isEqualToString:@""])
            {
            NSDictionary *gpsDict = [[NSDictionary alloc] initWithObjectsAndKeys:gps_region_id,@"region_id",gps_region_name,@"region_name",@[],@"childrens", nil];
            
            NSDictionary *gpsDict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"region_id",@"GPS Location",@"region_name",@[gpsDict],@"childrens", nil];
            
            [dataArray insertObject:gpsDict2 atIndex:0];
            }
            TheSameArr = [NSArray arrayWithArray:dataArray];
            //self.tableView.footer.hidden = (dataArray.count <=0) ? YES : NO;
            
            MYLOG(@"city data :%@",[responseObject objectForKey:@"data"]);
            //self.statusFrames = nil;
            
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
        [hud removeFromSuperview];
        MYLOG(@"请求失败");
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[dataArray objectAtIndex:section] objectForKey:@"childrens"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //cell.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *drow = [[[dataArray objectAtIndex:indexPath.section] objectForKey:@"childrens"] objectAtIndex:indexPath.row];
    [cell.textLabel setText:[drow objectForKey:@"region_name" ]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *drow = [[[dataArray objectAtIndex:indexPath.section] objectForKey:@"childrens"] objectAtIndex:indexPath.row];
    
    [BWCommon setUserInfo:@"region_id" value:[drow objectForKey:@"region_id" ]];
    [BWCommon setUserInfo:@"parent_region_id" value:[drow objectForKey:@"parent_id" ]];
    [BWCommon setUserInfo:@"region_name" value:[drow objectForKey:@"region_name" ]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[dataArray objectAtIndex:section] objectForKey:@"region_name"];
}
//滚动表格时键盘失去焦点
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    
}
#pragma mark-searchBarDelegate

//在搜索框中修改搜索内容时，自动触发下面的方法
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    

    
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
    MYLOG(@"%@",searchText);
    if (![searchText isEqualToString:@""]) {
        dataArray = [NSMutableArray arrayWithArray:TheSameArr];
        if (dataArray.count!=0) {
            //定义相关
            NSArray *ForOneArr = [[NSArray alloc]init];
            NSDictionary *ForTwoDic = [[NSDictionary alloc]init];
            //定义重组数据相关
            //        childrens数组
            //        NSMutableArray *ChildrensArr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *dataSeaarr = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<dataArray.count; i++) {
                NSMutableDictionary * ForThereDic = [NSMutableDictionary dictionaryWithDictionary:[dataArray objectAtIndex:i]];
                ForOneArr= [ForThereDic objectForKey:@"childrens"];
                //循环之前要清空
                NSMutableArray *ChildrensArr = [NSMutableArray arrayWithCapacity:0];
                for (int j=0; j<ForOneArr.count; j++) {
                    ForTwoDic = [ForOneArr objectAtIndex:j];
                    if ([BWCommon DoesItInclude:ForTwoDic[@"region_name"] withString:searchText]) {
                        //如果包含了这个String就把这整个添加进数据
                        [ChildrensArr addObject:ForTwoDic];
                    }
                }
                if (ChildrensArr.count>0) {
                    [ForThereDic setValue:ChildrensArr forKey:@"childrens"];
                    [dataSeaarr addObject:ForThereDic];
                    
                }
            }
            MYLOG(@"搜索结果%@",dataSeaarr);
            //展示搜索结果
            dataArray = [NSMutableArray arrayWithArray:dataSeaarr];
            [self.tableView reloadData];
        }

    }else
    {
    
        dataArray = [NSMutableArray arrayWithArray:TheSameArr];
        [self.tableView reloadData];
    }
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
