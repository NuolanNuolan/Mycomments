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
#import "PhotoViewController.h"
#import "AddMerchantViewController.h"
#import "AddCommentViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-50)];
    
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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareTouched:)];
    
    UIBarButtonItem *collectionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_collection.png"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionTouched:)];
    
    NSArray *barItems = [[NSArray alloc] initWithObjects:collectionButton,shareButton, nil];
    [self.navigationItem setRightBarButtonItems:barItems];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-50, size.width, 50)];
    [actionView setBackgroundColor: [BWCommon getRGBColor:0x3f3f3f]];
    [self.view addSubview:actionView];
    
    UIButton *photoButton = [self createActionButton:@"Photo" imageName:@"detail_btn_photos"];
    photoButton.frame = CGRectMake(20, 15, 100, 20);
    [actionView addSubview:photoButton];
    UIButton *merchantButton = [self createActionButton:@"Merchant" imageName:@"detail_btn_add"];
    merchantButton.frame = CGRectMake((size.width - 110)/2, 15, 110, 20);
    [actionView addSubview:merchantButton];
    UIButton *commentButton = [self createActionButton:@"Comment" imageName:@"detail_btn_comment"];
    commentButton.frame = CGRectMake(size.width - 115, 15, 115, 20);
    [actionView addSubview:commentButton];
    
    [photoButton addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [merchantButton addTarget:self action:@selector(merchantTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [commentButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void) merchantTouched:(UIButton *) sender{
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        __weak ShopDetailViewController *weakSelf = self;
        
        UIViewController *viewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            [weakSelf.tableView reloadData];
        }];
        
        return;
    }
    
    AddMerchantViewController *viewController = [[AddMerchantViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

- (void) commentTouched:(UIButton *) sender{
    
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        __weak ShopDetailViewController *weakSelf = self;
        
        UIViewController *viewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            [weakSelf.tableView reloadData];
        }];
        
        return;
    }
    
    AddCommentViewController *viewController = [[AddCommentViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}


-(void) likeTouched:(UIButton *) sender{
    NSLog(@"%ld",sender.tag);
    BOOL isLoggedIn = [BWCommon isLoggedIn];
    
    if (!isLoggedIn) {
        
        //__weak CommentViewController *weakSelf = self;
        
        UIViewController *viewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
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
        
        NSLog(@"%@",responseObject);
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
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
        }
    } fail:^{
        [hud removeFromSuperview];
    }];
    
    
}

- (void) imageTouched:(UIButton *) sender{
    
    PhotoViewController *photoView = [[PhotoViewController alloc] init];
    photoView.sid = sender.tag;
    photoView.shop_name = [[shopDict objectForKey:@"shop"] objectForKey:@"name"];
    
    [self.navigationController pushViewController:photoView animated:YES];
}

-(void) shareTouched: (UIBarButtonItem *) sender{

    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/

    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    
    NSString *image_url = [[shopDict objectForKey:@"shop"] objectForKey:@"small_image"];
    
    image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@",[BWCommon getBaseInfo:@"site_url"],image_url];
    NSString *shop_name = [[shopDict objectForKey:@"shop"] objectForKey:@"name"];
    
    [shareParams SSDKSetupShareParamsByText:shop_name
                                     images:@[image_url]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mycomments.com.my/shop/%ld",self.sid]]
                                      title:shop_name
                                       type:SSDKContentTypeAuto];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];

    //2、分享
    [ShareSDK showShareActionSheet:self.view
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
    
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks for your sharing"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"Ok"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;

                       }
                       case SSDKResponseStateCancel:
                       {
                           
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
}

-(void) collectionTouched: (UIBarButtonItem *) sender{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"addCollection"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",self.sid] forKey:@"sid"];
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];
        if(code == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"System Tips" message:@"Action successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"System Tips" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
    }];

}

- (UIButton *) createActionButton:(NSString *) title imageName:(NSString *) imageName{
    
    UIButton *button = [[UIButton alloc] init];
    
    UIImage *icon = [UIImage imageNamed:imageName];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.frame = CGRectMake(0, 0, 22, 20);
    [button addSubview:iconView];
    //[photoButton setBackgroundImage:[UIImage imageNamed:@"detail_btn_photos"] forState:UIControlStateNormal];
    [button setTitleColor:[BWCommon getRGBColor:0xffffff] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    return button;
    //[photoButton setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0.0, 40.0, 0.0)];
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

        [cell.imageButton addTarget:self action:@selector(imageTouched:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if(indexPath.section == 5) {
        CommentMainTableViewCell *cell = [CommentMainTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.statusFrames[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.likeButton addTarget:self action:@selector(likeTouched:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){
        
        NSString *number = [[shopDict objectForKey:@"shop"] objectForKey:@"tel"];
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
        
        //UIWebView * callWebview = [[UIWebView alloc] init];
        //[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:num]]];
        //[self.view addSubview:callWebview];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}

- (void) headerRefreshing{
    
    //self.gpage = 1;
    [self refreshingData:self.sid callback:^{
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
    
    hud = [BWCommon getHUD];
    //hud.mode = MBProgressHUDModeDeterminate;
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
            
            NSLog(@"%@",shopDict);
            
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



-(void) uploadTouched:(UIButton *)sender{
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"Add Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Gallery", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}



- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [self snapImage];
        
    }else if(buttonIndex==1){
        [self pickImage];
    }
    
}

//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
        
        
    }];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    int y = (arc4random() % 1001) + 9000;
    
    NSString *fileName = [NSString stringWithFormat:@"%d%@",y,@".jpg"];
    
    [self saveImage:img WithName:fileName];
    
    NSString *fullFileName = [[self documentFolderPath] stringByAppendingPathComponent:fileName];
    
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:fullFileName];
    //NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSLog(@"%@",fileUrl);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    NSString *api_url = @"http://hj.s10.baiwei.org/member/register/upload_img";
    
    NSDictionary *postData = @{@"password":[BWCommon getUserInfo:@"password"],@"uniqueid":[BWCommon getUserInfo:@"uid"]};
    
    
    [AFNetworkTool postUploadWithUrl:api_url fileUrl:fileUrl parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        
        NSLog(@"%@",responseObject);
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else
        {
            NSString *imgurl = [[responseObject objectForKey:@"data"] objectForKey:@"imgurl"];
            NSString *imgview = [[responseObject objectForKey:@"data"] objectForKey:@"imgview"];
            
            //图片获取的token
            NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
            NSString *uid = [BWCommon getUserInfo:@"uid"];
            
            //NSLog(@"uniqueid:%@",uid);
            
            NSString *str = [NSString stringWithFormat:@"register/display_cert_image/%@/%@",timestamp,[BWCommon md5:uid]];
            
            
            //init token
            NSString *token = [BWCommon md5:str];
            
            NSString *nimgview = [[NSString alloc] init];
            nimgview = [imgview stringByReplacingOccurrencesOfString:@"http://www.huaji.com/" withString:@"http://hj.s10.baiwei.org/"];
            nimgview = [NSString stringWithFormat:@"%@?token=%@&time=%@&uid=%@",nimgview,token,timestamp,uid];
            NSURL *dataurl = [NSURL URLWithString:nimgview];
            
            NSLog(@"%@",dataurl);
            
            NSData* ndata = [NSData dataWithContentsOfURL:dataurl];
            
            //NSLog(@"%@",ndata);
            //[self.testImage sd_setImageWithURL:dataurl];
            
            if(photo_type==1){
                face_pic = imgurl;
                
                [self.photo1Button setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            }
            else if(photo_type==2){
                back_pic = imgurl;
                
                [self.photo2Button setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            }
            
            NSLog(@"%@",imgurl);
        }
        
    } fail:^{
        
        [hud removeFromSuperview];
        
        [alert setMessage:@"请求超时，请稍候重试"];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    */
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
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
