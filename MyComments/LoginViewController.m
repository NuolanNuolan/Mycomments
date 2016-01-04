//
//  LoginViewController.m
//  MyComments
//
//  Created by Bruce on 15-9-10.
//
//

#import "LoginViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

UITextField *username;
UITextField *password;

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void) pageLayout {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTouched:)];
    
    UIBarButtonItem *registerItem = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(registerTouched:)];
    
    self.navigationItem.leftBarButtonItem = closeItem;
    self.navigationItem.rightBarButtonItem = registerItem;
    [self.navigationItem setTitle:@"Sign In"];
    //[navigationBar pushNavigationItem:navigationItem animated:YES];
    
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    username = [self createTextField:@"label_email" Title:@"Cellphone/Username/Email"];
    username.frame = CGRectMake(15,20,size.width-30,50);
    [sclView addSubview:username];
    username.delegate = self;
    self.username = username;
    
    password = [self createTextField:@"label_pwd" Title:@"Password"];
    password.frame = CGRectMake(15, 90, size.width-30, 50);
    password.secureTextEntry = YES;
    password.delegate = self;
    [sclView addSubview:password];
    self.password = password;
    
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width-140, 155, 130, 20)];
    [forgetButton setTitle:@"forget password?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[BWCommon getRGBColor:0x111111] forState:UIControlStateNormal];
    [forgetButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [sclView addSubview:forgetButton];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogin.frame = CGRectMake(15 , 190, size.width-30, 50);
    [btnLogin.layer setMasksToBounds:YES];
    [btnLogin.layer setCornerRadius:5.0];
    //btnLogin.translatesAutoresizingMaskIntoConstraints = NO;
    btnLogin.backgroundColor =[BWCommon getRGBColor:0xff0000];
    btnLogin.tintColor = [UIColor whiteColor];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnLogin setTitle:@"Sign In" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(loginTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnLogin];
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 45, 250, 30, 30)];
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    
    [sclView addSubview:facebookButton];

    
}


- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    icon.frame = CGRectMake(20, 10, 36, 36);
    field.leftView = icon;
    field.leftViewMode = UITextFieldViewModeAlways;
    //field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

- (void) closeTouched:(UIBarButtonItem *) sender{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) registerTouched:(UIBarButtonItem *) sender{
    
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void) loginTouched: (id)sender
{
    NSString *usernameValue = username.text;
    NSString *passwordValue = password.text;
    

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if([usernameValue isEqualToString:@""])
    {
        [alert setMessage:@"Please input your username"];
        [alert show];
        return;
    }
    
    if([passwordValue isEqualToString:@""])
    {
        [alert setMessage:@"Please input your password"];
        [alert show];
        return;
    }
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"login"];
    
    NSDictionary *postData = @{@"username":usernameValue,@"password":passwordValue};
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        [hud removeFromSuperview];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        
        if (code != 200) {
            [alert setMessage:[responseObject objectForKey:@"msg"]];
            [alert show];
        }
        else
        {
            NSDictionary *user = [responseObject objectForKey:@"msg"];
            [BWCommon setUserInfo:@"uid" value:[user objectForKey:@"uid"]];
            [BWCommon setUserInfo:@"username" value:[user objectForKey:@"username"]];
            
            //同步用户信息
            [BWCommon syncUserInfo];
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"Network connection timeout."];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    
    
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
