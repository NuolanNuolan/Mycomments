//
//  SearchTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "BWCommon.h"
#import "ShopViewController.h"
#import "SearchResultsViewController.h"
#import "AFNetworkTool.h"

@interface SearchTableViewController ()

@property (nonatomic,retain) NSMutableArray *list;

//searchResult
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SearchTableViewController

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pageLayout];
}

- (void)pageLayout {
    
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
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width - 140, 30)];
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width - 140, 30)];
    //[searchButton setBackgroundImage:[UIImage imageNamed:@"navbar_search"] forState:UIControlStateNormal];
    
    [searchButton setBackgroundColor:[UIColor whiteColor]];
    [searchButton.layer setCornerRadius:8.0f];
    [searchButton setTitle:@"Search for shop name" forState:UIControlStateNormal];
    [searchButton setTitleColor:[BWCommon getRGBColor:0x999999] forState:UIControlStateNormal ];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    UIImageView *iconQuery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-query"]];
    [searchButton addSubview:iconQuery];
    
    CGRect qRect = iconQuery.frame;
    qRect.origin.x = 10;
    qRect.origin.y = 5;
    iconQuery.frame = qRect;
    
    
    
    [searchButton addTarget:self action:@selector(searchTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [middleView addSubview:searchButton];
    [self.navigationItem setTitleView:middleView];
    
    
    self.list = [[NSMutableArray alloc] initWithCapacity:3];
    [self.list addObject:[self createRow:@"Restaurant" icon:@"home_restaurant_icon"]];
    [self.list addObject:[self createRow:@"Life & Style" icon:@"home_life_style_icon"]];
    [self.list addObject:[self createRow:@"Travel" icon:@"home_travel_icon"]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
}


-(void) searchTouched: (UIButton *) sender{
    
    
    SearchResultsViewController *resultTableViewController = [[SearchResultsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultTableViewController];
    
    self.searchController = searchController;
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self presentViewController:searchController animated:YES completion:nil];
}


-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    //获取搜索字符串
    NSString * searchString = searchController.searchBar.text;
    //根据输入的字符串找到和之匹配的字符串
    //[self updateFilteredContent:searchString];
    
    if (searchController.searchResultsController) {
        NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"search"];
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        
        [postData setValue:searchString forKey:@"q"];
        MYLOG(@"%@",url);
        //load data
        [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
            
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            //[hud removeFromSuperview];
            if(code == 200)
            {
                NSMutableDictionary *data = [responseObject objectForKey:@"data"];
                
                // 在查询之前需要清理或者初始化数组：懒加载
                if (self.searchResults != nil) {
                    [self.searchResults removeAllObjects];
                }
                
                self.searchResults = [[data objectForKey:@"lists"] mutableCopy];
                
                //获取UISearchController的searchResultsController
                SearchResultsViewController * resultsVC = (SearchResultsViewController *)searchController.searchResultsController;
                //将符合条件的数据赋值给searchResultsController
                resultsVC.searchResults = self.searchResults;
                [resultsVC.tableView reloadData];
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
}

- (NSDictionary *) createRow:(NSString *) title  icon: (NSString *) icon{
    
    NSDictionary *row = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title,@"title", icon,@"icon", nil];
    return row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *identifier = @"cell2";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        cell.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *menu = self.list[indexPath.row];
    cell.textLabel.text = [menu objectForKey:@"title"];
    
    UIImage *icon = [UIImage imageNamed:[menu objectForKey:@"icon"]];
    [cell.imageView setImage:icon];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ShopViewController *viewController = [[ShopViewController alloc] init];
    //self.detailDelegate = viewController;
    self.delegate = viewController;
    [self.delegate setValue:0 cid:indexPath.row+2 region_name:@"" cat_name:@""];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}


@end
