//
//  MemberTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import "MemberTableViewController.h"
#import "UserTableViewCell.h"
#import "UserTableViewFrame.h"
#import "MAvatarTableViewCell.h"
#import "AvatarTableViewFrame.h"
#import "BWCommon.h"
#import "CommentViewController.h"
#import "MyPhotoViewController.h"
#import "MyShopViewController.h"
#import "MyFansViewController.h"
#import "MyFollowersViewController.h"
#import "AFNetworkTool.h"

@interface MemberTableViewController ()

@property (nonatomic,strong) NSArray *statusFrames;
@property (nonatomic,strong) NSArray *avatarFrames;

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) NSMutableArray *sectionList;
@property (nonatomic,retain) NSMutableDictionary *baseInfo;


@end

@implementation MemberTableViewController

CGSize size;

NSString *mFansNumber=@"";
NSString *mFollwersNumber = @"";
NSString *mPointsNumber = @"";
NSString *mIntroduction = @"";

NSString *username = @"";


NSString *imgurl;

bool mLoadedData=YES;

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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.navigationItem.title = @"Member";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    
    self.list = [[NSMutableArray alloc] initWithCapacity:1];
    
    // NSMutableArray *menu1 = [[NSMutableArray alloc] init];
    // [menu1 addObject:[self createRow:@"brucehe3" text:@"" icon:@"noavatar_large"]];
    
    self.baseInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"MyComments",@"title",@"",@"text",@"noavatar_large",@"avatar", nil];
    // self.list[0] = menu1;
    
    NSMutableArray *menu2 = [[NSMutableArray alloc] init];
    [menu2 addObject:[self createRow:@"Comments" text:@"0" icon:@"member_comments"]];
    [menu2 addObject:[self createRow:@"Collections" text:@"0" icon:@"member_collection"]];
    [menu2 addObject:[self createRow:@"Photos" text:@"0" icon:@"member_photos"]];
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
    
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    //NSString *username = [BWCommon getUserInfo:@"username"];
    
    NSString *url =  [NSString stringWithFormat:@"%@user?username=%@",[BWCommon getBaseInfo:@"api_url"],username ];
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
    
        mLoadedData = NO;
        MYLOG(@"%@",json);
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            NSDictionary *udata = [json objectForKey:@"data"];
            
            
            NSString *avatar = [NSString stringWithFormat:@"%@%@",[BWCommon getBaseInfo:@"site_url"],[udata objectForKey:@"avatar_small"]];
            
            self.baseInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[udata objectForKey:@"username"],@"title",[udata objectForKey:@"email"],@"text",avatar,@"avatar", nil];
            
            self.avatarFrames = nil;
            self.statusFrames = nil;
            
            
            NSMutableArray *menu2 = [[NSMutableArray alloc] init];
            [menu2 addObject:[self createRow:@"Comments" text:[udata objectForKey:@"comments"] icon:@"member_comments"]];
            [menu2 addObject:[self createRow:@"Collections" text:[udata objectForKey:@"collections_count"] icon:@"member_collection"]];
            [menu2 addObject:[self createRow:@"Photos" text:[udata objectForKey:@"photos_count"] icon:@"member_photos"]];
            self.list[0] = menu2;
            
            //MYLOG(@"%@",menu2);
            
            mFansNumber = [udata objectForKey:@"followers_count"];
            mFollwersNumber = [udata objectForKey:@"followings_count"];
            mPointsNumber = [udata objectForKey:@"points"];
            
            if([[udata objectForKey:@"intro"] isEqual:[NSNull null]])
                mIntroduction = @"";
            else
                mIntroduction = [udata objectForKey:@"intro"];
            
            [self.tableView reloadData];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:[json objectForKey:@"data"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
            MYLOG(@"%@",[json objectForKey:@"data"]);
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
        MAvatarTableViewCell *cell = [MAvatarTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.avatarFrames[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.followButton addTarget:self action:@selector(followTouched:) forControlEvents:UIControlEventTouchUpInside];

        
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //[cell.contentView addSubview:self.photoButton];
     

        
        return cell;
        
    }
    else if (indexPath.section == 2)
    {
        UserTableViewCell * cell = [UserTableViewCell cellWithTableView:tableView];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        //if(indexPath.section==1){
        cell.viewFrame = self.statusFrames[indexPath.section-2][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.sep
        //    cell.textLabel.font = [UIFont systemFontOfSize:14];
        //}
        
        return cell;
    }
    else{
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        //if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        //}
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *fansView = [self createCellView:@"Fans" icon:@"ico-item4-active" number:mFansNumber tag:1];
        fansView.frame = CGRectMake(0, 0, size.width/3, 50);
        
        
        [BWCommon setRightBorder:fansView color:[BWCommon getRGBColor:0xdddddd]];
        
        [cell addSubview:fansView];
        
        UIView *followsView = [self createCellView:@"Follows" icon:@"ico-item4" number:mFollwersNumber tag:2];
        followsView.frame = CGRectMake(size.width/3, 0, size.width/3, 50);
        
        [BWCommon setRightBorder:followsView color:[BWCommon getRGBColor:0xdddddd]];
        
        [cell addSubview:followsView];
        
        UIView *pointsView = [self createCellView:@"Points" icon:@"icon-point2" number:mPointsNumber tag:3];
        pointsView.frame = CGRectMake(size.width/3*2, 0, size.width/3, 50);
        
        [cell addSubview:pointsView];
        
        UIView *introductView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, size.width, 70)];
        
        /*UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, size.width, 20)];
         [titleLabel setText:@"Introduction"];
         [titleLabel setFont:[UIFont systemFontOfSize:14]];
         [titleLabel setTextColor:[BWCommon getRGBColor:0x333333]];*/
        
        [BWCommon setTopBorder:introductView color:[BWCommon getRGBColor:0xdddddd]];
        //[introductView addSubview:titleLabel];
        
        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width - 20, 50)];
        [introLabel setText:mIntroduction];
        [introLabel setFont:[UIFont systemFontOfSize:12]];
        [introLabel setTextColor:[BWCommon getRGBColor:0x666666]];
        
        [introductView addSubview:introLabel];
        
        [cell addSubview:introductView];
        
        return cell;
        
    }
    
}

-(void) followTouched:(UIButton *) sender{
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    if(!isLoggedIn)
    {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginView"];
        if (viewController) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [self presentViewController:navigationController animated:YES completion:^{}];
 
        }
        
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [NSString stringWithFormat:@"%@follow",[BWCommon getBaseInfo:@"api_url"] ];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    [postData setValue:username forKey:@"fusername"];
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSDictionary *json = responseObject;
        
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"You have successfully followed this user" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            [self.tableView reloadData];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:[json objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            MYLOG(@"%@",[json objectForKey:@"msg"]);
        }
    } fail:^{
        [hud removeFromSuperview];
    }];
    
    
}

-(void) iconAction: (UIButton *)sender{
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    if(!isLoggedIn)
        return;
    
    MYLOG(@"iconAction: %ld",sender.tag);
    if(sender.tag == 1){
        MyFansViewController *viewController = [[MyFansViewController alloc] init];
        self.memberDelegate = viewController;
        [self.memberDelegate setValue:username];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(sender.tag == 2){
        MyFollowersViewController *viewController = [[MyFollowersViewController alloc] init];
        self.memberDelegate = viewController;
        [self.memberDelegate setValue:username];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(UIView *) createCellView:(NSString *) title icon:(NSString *)icon number:(NSString *)number tag:(NSInteger) tag{
    
    UIView *cview = [[UIView alloc] init];
    
    UIButton *btnIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    
    [btnIcon setBackgroundColor:[UIColor whiteColor]];
    
    [btnIcon addTarget:self action:@selector(iconAction:) forControlEvents:UIControlEventTouchUpInside];
    btnIcon.tag = tag;
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    iconView.frame = CGRectMake(15, 10, 20, 20);
    [btnIcon addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 20)];
    [titleLabel setText:title];
    //[titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnIcon addSubview:titleLabel];
    
    [cview addSubview:btnIcon];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 26, 60, 20)];
    [numberLabel setText:number];
    [numberLabel setFont:[UIFont systemFontOfSize:12]];
    [numberLabel setTextColor:[BWCommon getRGBColor:0x999999]];
    [cview addSubview:numberLabel];
    
    return cview;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 80;
    else if(indexPath.section == 1)
        return 120;
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
    
    
    return footerView;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section==2) {
        
        if(indexPath.row == 0){
            CommentViewController *viewController = [[CommentViewController alloc] init];
            self.memberDelegate = viewController;
            [self.memberDelegate setValue:username];
            
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.myComments = YES;
            //是否是自己的评论
            viewController.ismyComments=NO;
            [self.navigationController pushViewController:viewController animated:YES];
       }else if(indexPath.row == 1){
            MyShopViewController *viewController = [[MyShopViewController alloc] init];
            self.memberDelegate = viewController;
            [self.memberDelegate setValue:username];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else if(indexPath.row == 2){
            MyPhotoViewController *viewController = [[MyPhotoViewController alloc] init];
            self.memberDelegate = viewController;
            [self.memberDelegate setValue:username];
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
                MYLOG(@"%@",dict);
                [tmp addObject:vf];
            }
            
            
            [models addObject:tmp];
        }
        self.statusFrames = [models copy];
    }
    
    
    return _statusFrames;
}

-(void) setValue:(NSString *)usernameValue{
    username = usernameValue;
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
