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

@interface RegionTableViewController ()


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
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
    
    [self.tableView setTableHeaderView:searchBar];
    
    //searchBar.text = @"Search";
    //searchBar add
    
    [self refreshingData:^{}];
}


- (void) refreshingData:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"citylistbyprovince"];

    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            dataArray = [[responseObject objectForKey:@"data"] mutableCopy];

            //self.tableView.footer.hidden = (dataArray.count <=0) ? YES : NO;
            
            NSLog(@"city data :%@",[responseObject objectForKey:@"data"]);
            //self.statusFrames = nil;
            
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            
            if(callback){
                callback();
            }
            
            //NSLog(@"%@",json);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
