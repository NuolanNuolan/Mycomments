//
//  UserTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import "UserTableViewController.h"
#import "UserTableViewCell.h"
#import "UserTableViewFrame.h"
#import "AvatarTableViewCell.h"
#import "AvatarTableViewFrame.h"
#import "BWCommon.h"
#import "CommentViewController.h"
#import "MyPhotoViewController.h"
#import "MyShopViewController.h"
#import "AFNetworkTool.h"

@interface UserTableViewController ()

@property (nonatomic,strong) NSArray *statusFrames;
@property (nonatomic,strong) NSArray *avatarFrames;

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) NSMutableArray *sectionList;
@property (nonatomic,retain) NSMutableDictionary *baseInfo;

@end

@implementation UserTableViewController

CGSize size;

NSString *fansNumber=@"";
NSString *follwersNumber = @"";
NSString *pointsNumber = @"";

bool loadedData=YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self pagelayout];
}

-(void) viewDidAppear:(BOOL)animated{
    
    
    if([[BWCommon getUserInfo:@"need_refresh"] isEqualToString:@"1"]){
        [self loadUserData];
        [BWCommon setUserInfo:@"need_refresh" value:@"0"];
    }
}

- (void) pagelayout{
 
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    self.navigationItem.title = @"My";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    
    self.list = [[NSMutableArray alloc] initWithCapacity:1];
   
   // NSMutableArray *menu1 = [[NSMutableArray alloc] init];
   // [menu1 addObject:[self createRow:@"brucehe3" text:@"" icon:@"noavatar_large"]];
    
    self.baseInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"MyComments",@"title",@"",@"text",@"noavatar_large",@"avatar", nil];
   // self.list[0] = menu1;
    
    NSMutableArray *menu2 = [[NSMutableArray alloc] init];
    [menu2 addObject:[self createRow:@"Comments" text:@"" icon:@"member_comments"]];
    [menu2 addObject:[self createRow:@"Collections" text:@"" icon:@"member_collection"]];
    [menu2 addObject:[self createRow:@"Photos" text:@"" icon:@"member_photos"]];
    self.list[0] = menu2;
    
    //NSMutableArray *menu3 = [[NSMutableArray alloc] init];
    //[menu3 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];

    //self.list[1] = menu3;
    
    [self loadUserData];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    
    
    

}
- (NSDictionary *) createRow:(NSString *) title  text: (NSString *) text icon: (NSString *) icon{
    
    NSDictionary *row = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title,@"title",text,@"text", icon,@"icon", nil];
    return row;
}

-(void) loadUserData{
    
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        //__weak UserTableViewController *weakSelf = self;
        
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            //[weakSelf.tableView reloadData];
            //[weakSelf loadUserData];
        }];
        
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *username = [BWCommon getUserInfo:@"username"];

    NSString *url =  [NSString stringWithFormat:@"%@user?username=%@",[BWCommon getBaseInfo:@"api_url"],username ];
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        
        loadedData = NO;
        NSLog(@"%@",json);
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            NSDictionary *udata = [json objectForKey:@"data"];
            
            
            NSString *avatar = [NSString stringWithFormat:@"%@%@",[BWCommon getBaseInfo:@"site_url"],[udata objectForKey:@"avatar_small"]];
            
            self.baseInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[udata objectForKey:@"username"],@"title",[udata objectForKey:@"email"],@"text",avatar,@"avatar", nil];
            
            self.avatarFrames = nil;
            
            
            NSMutableArray *menu2 = [[NSMutableArray alloc] init];
            [menu2 addObject:[self createRow:@"Comments" text:[udata objectForKey:@"comments"] icon:@"member_comments"]];
            [menu2 addObject:[self createRow:@"Collections" text:[udata objectForKey:@"collections_count"] icon:@"member_collection"]];
            [menu2 addObject:[self createRow:@"Photos" text:[udata objectForKey:@"photos_count"] icon:@"member_photos"]];
            self.list[0] = menu2;
            
            follwersNumber = [udata objectForKey:@"followers_count"];
            fansNumber = [udata objectForKey:@"followings_count"];
            pointsNumber = [udata objectForKey:@"points"];
            
            [self.tableView reloadData];
        
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:[json objectForKey:@"data"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
            NSLog(@"%@",[json objectForKey:@"data"]);
        }
    } fail:^{
        [hud removeFromSuperview];
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
    
    if(section == 2)
        return 3;
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0)
    {
        AvatarTableViewCell *cell = [AvatarTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.avatarFrames[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(indexPath.row>0){
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-edit"]];
            [cell.contentView addSubview:icon];
            
            if(indexPath.row==1){
                icon.frame = CGRectMake(184, 12, 24, 24);
            }else{
                icon.frame = CGRectMake(120, 12, 24, 24);
            }
        }
        
        return cell;

    }
    else if (indexPath.section == 2)
    {
        UserTableViewCell * cell = [UserTableViewCell cellWithTableView:tableView];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        //if(indexPath.section==1){
        cell.viewFrame = self.statusFrames[indexPath.section-2][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //    cell.textLabel.font = [UIFont systemFontOfSize:14];
        //}

        return cell;
    }
    else{
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        //if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        //}
        
        UIView *fansView = [self createCellView:@"Fans" icon:@"ico-item4-active" number:fansNumber];
        fansView.frame = CGRectMake(0, 0, size.width/3, 50);
        
        
        [BWCommon setRightBorder:fansView color:[BWCommon getRGBColor:0xdddddd]];
        
        [cell addSubview:fansView];
        
        UIView *followsView = [self createCellView:@"Follows" icon:@"ico-item4" number:follwersNumber];
        followsView.frame = CGRectMake(size.width/3, 0, size.width/3, 50);
        
        [BWCommon setRightBorder:followsView color:[BWCommon getRGBColor:0xdddddd]];
        
        [cell addSubview:followsView];
        
        UIView *pointsView = [self createCellView:@"Points" icon:@"icon-point" number:pointsNumber];
        pointsView.frame = CGRectMake(size.width/3*2, 0, size.width/3, 50);
        
        [cell addSubview:pointsView];
        
        return cell;
    
    }
    
}

-(UIView *) createCellView:(NSString *) title icon:(NSString *)icon number:(NSString *)number{
    
    UIView *cview = [[UIView alloc] init];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    iconView.frame = CGRectMake(15, 10, 20, 20);
    [cview addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 20)];
    [titleLabel setText:title];
    //[titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cview addSubview:titleLabel];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 26, 60, 20)];
    [numberLabel setText:number];
    [numberLabel setFont:[UIFont systemFontOfSize:12]];
    [numberLabel setTextColor:[BWCommon getRGBColor:0x999999]];
    [cview addSubview:numberLabel];
    
    return cview;
}

-(void) logoutTouched: (UIButton *) sender{
    
    [BWCommon logout];
    self.avatarFrames = nil;
    //self.statusFrames = nil;
    self.baseInfo = nil;

    follwersNumber = @"";
    fansNumber = @"";
    pointsNumber = @"";
    //[self loadUserData];
    [self.tableView reloadData];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 80;
    else if(indexPath.section == 1)
        return 50;
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 2){
        return 60;
    }
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        return 0;
    }
    return 20;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    [headerView sizeToFit];
        
    [BWCommon setTopBorder:headerView color:[BWCommon getBorderColor]];
    [BWCommon setBottomBorder:headerView color:[BWCommon getBorderColor]];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    
    [footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    [footerView sizeToFit];
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if(isLoggedIn){
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, size.width-30, 40)];
        [logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        [logoutButton.layer setCornerRadius:5.0f];
        [logoutButton setBackgroundColor:[BWCommon getRedColor]];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [logoutButton addTarget:self action:@selector(logoutTouched:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutButton];
        
        //cell.backgroundColor = [UIColor whiteColor];
    }
    
    return footerView;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        //__weak UserTableViewController *weakSelf = self;
        
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            //[weakSelf loadUserData];
        }];
        
        return;
    }
    
    if (indexPath.section==2) {
        
        if(indexPath.row == 0){
            CommentViewController *viewController = [[CommentViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.myComments = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else if(indexPath.row == 1){
            MyShopViewController *viewController = [[MyShopViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else if(indexPath.row == 2){
            MyPhotoViewController *viewController = [[MyPhotoViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
}



- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
        
        for (int i=0;i < self.list.count;i++){
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [self.list objectAtIndex:i]) {
                // 创建模型
                UserTableViewFrame *vf = [[UserTableViewFrame alloc] init];
                vf.data = dict;
                //NSLog(@"%@",dict);
                [tmp addObject:vf];
            }
            
            
            [models addObject:tmp];
        }
        self.statusFrames = [models copy];
    }
    
    
    return _statusFrames;
}

- (NSArray *)avatarFrames
{
    if (_avatarFrames == nil) {
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:1];
        AvatarTableViewFrame *af = [[AvatarTableViewFrame alloc] init];
        af.data = self.baseInfo;
        [models addObject:af];
        
        
        self.avatarFrames = [models copy];
    }

    return _avatarFrames;
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
