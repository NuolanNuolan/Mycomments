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

@interface SearchTableViewController ()

@property (nonatomic,retain) NSMutableArray *list;

@end

@implementation SearchTableViewController

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
    
    
    self.list = [[NSMutableArray alloc] initWithCapacity:3];
    [self.list addObject:[self createRow:@"Restaurant" icon:@"home_restaurant_icon"]];
    [self.list addObject:[self createRow:@"Life & Style" icon:@"home_life_style_icon"]];
    [self.list addObject:[self createRow:@"Travel" icon:@"home_travel_icon"]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
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
    return 60;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ShopViewController *viewController = [[ShopViewController alloc] init];
    //self.detailDelegate = viewController;
    self.delegate = viewController;
    [self.delegate setValue:0 cid:indexPath.row+1 region_name:@"" cat_name:@""];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}


@end
