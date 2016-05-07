//
//  ForgetStep3ViewController.m
//  MyComments
//
//  Created by Bruce on 16/3/21.
//
//

#import "ForgetStep3ViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface ForgetStep3ViewController ()

@end

@implementation ForgetStep3ViewController

CGSize size;


UITextField *password;
UITextField *confirmpassword;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self pageLayout];
}

- (void) pageLayout{
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationItem setTitle:@"Reset password"];
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width, 30)];
    [tipsLabel setText:@"Please reset your password."];
    
    [sclView addSubview:tipsLabel];

    
    password = [self createTextField:@"label_pwd" Title:@"New Password"];
    password.frame = CGRectMake(15,50,size.width-30,50);
    password.secureTextEntry = YES;
    [sclView addSubview:password];
    password.delegate = self;
    self.password = password;
    
    [sclView addSubview:password];
    
    confirmpassword = [self createTextField:@"label_pwd" Title:@"Confirm Password"];
    confirmpassword.frame = CGRectMake(15,120,size.width-30,50);
    confirmpassword.secureTextEntry = YES;
    [sclView addSubview:confirmpassword];
    confirmpassword.delegate = self;
    self.confirmpassword = confirmpassword;
    
    [sclView addSubview:password];
    
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDone.frame = CGRectMake(15 , 190, size.width-30, 50);
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
    

    if([self.password.text isEqualToString:@""]){
        [alert setMessage:@"Please enter your password"];
        [alert show];
        return;
    }
    
    if(![self.password.text isEqualToString:self.confirmpassword.text]){
        [alert setMessage:@"Please double check your password"];
        [alert show];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"forgetpwd3"];
    
    NSDictionary *postData = @{@"cellphone":self.cellphone,@"password":self.password.text};
    
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
            [alert setMessage:@"You have successfully reset the password!"];
            [alert show];
            
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
