//
//  Register2ViewController.m
//  MyComments
//
//  Created by Bruce on 15/9/27.
//
//

#import "Register2ViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
@interface Register2ViewController ()

@end

@implementation Register2ViewController

CGSize size;

UITextField *username;
UITextField *password;
UITextField *code;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationItem setTitle:@"Register"];
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    

    code = [self createTextField:@"label_pwd" Title:@"Pin Number"];
    code.frame = CGRectMake(15,20,size.width-30,50);
    [sclView addSubview:code];
    code.delegate = self;
    self.code = code;
    
    [sclView addSubview:code];
    
    username = [self createTextField:@"label_email" Title:@"User Name"];
    username.frame = CGRectMake(15,90,size.width-30,50);
    [sclView addSubview:username];
    username.delegate = self;
    self.username = username;
    
    [sclView addSubview:username];
    
    
    password = [self createTextField:@"label_pwd" Title:@"Password"];
    password.frame = CGRectMake(15,160,size.width-30,50);
    password.secureTextEntry = YES;
    [sclView addSubview:password];
    password.delegate = self;
    self.password = password;
    
    [sclView addSubview:password];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDone.frame = CGRectMake(15 , 230, size.width-30, 50);
    [btnDone.layer setMasksToBounds:YES];
    [btnDone.layer setCornerRadius:5.0];
    btnDone.backgroundColor =[BWCommon getRGBColor:0xff0000];
    btnDone.tintColor = [UIColor whiteColor];
    btnDone.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(nextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnDone];
}


- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    icon.frame = CGRectMake(20, 10, 30, 20);
    field.leftView = icon;
    field.leftViewMode = UITextFieldViewModeAlways;
    //field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

-(void) nextTouched:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if([self.code.text isEqualToString:@""]){
        [alert setMessage:@"Please enter pin number."];
        [alert show];
        return;
    }
    
    if([self.username.text isEqualToString:@""]){
        [alert setMessage:@"Please enter user name."];
        [alert show];
        return;
    }
    if([self.password.text isEqualToString:@""]){
        [alert setMessage:@"Please enter your password"];
        [alert show];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addUser2"];
    
    NSDictionary *postData = @{@"cellphone":self.cellphone,@"username":self.username.text,@"password":self.password.text,@"code":self.code.text};
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        MYLOG(@"%@",responseObject);
        
        [hud removeFromSuperview];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        
        if (code != 200) {
            [alert setMessage:[responseObject objectForKey:@"msg"]];
            [alert show];
        }
        else
        {
            [alert setMessage:@"You have successfully completed the registration!"];
            [alert show];

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
        
        MYLOG(@"请求失败");
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
