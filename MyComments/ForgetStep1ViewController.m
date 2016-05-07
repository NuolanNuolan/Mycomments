//
//  ForgetStep1ViewController.m
//  MyComments
//
//  Created by Bruce on 16/3/21.
//
//

#import "ForgetStep1ViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "ForgetStep2ViewController.h"

@interface ForgetStep1ViewController ()

@end

@implementation ForgetStep1ViewController

UITextField *username;

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pageLayout {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationItem setTitle:@"Forget password"];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width, 30)];
    [tipsLabel setText:@"On time pin will be sent to your cell phone."];
    
    [sclView addSubview:tipsLabel];
    
    username = [self createTextField:@"label_email" Title:@"Your Phone Number"];
    //username.placeholder = @"Startwith country code";
    username.frame = CGRectMake(15,50,size.width-30,50);
    [sclView addSubview:username];
    username.delegate = self;
    self.username = username;
    
    [sclView addSubview:username];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 95, size.width, 30)];
    
    [sclView addSubview:phoneLabel];
    [phoneLabel setText:@"Start with country code."];
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneLabel setTextColor:[BWCommon getRGBColor:0x888888]];
    

    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnNext.frame = CGRectMake(15 , 150, size.width-30, 50);
    [btnNext.layer setMasksToBounds:YES];
    [btnNext.layer setCornerRadius:5.0];
    btnNext.backgroundColor =[BWCommon getRGBColor:0xff0000];
    btnNext.tintColor = [UIColor whiteColor];
    btnNext.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnNext setTitle:@"Next step" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(nextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnNext];
    
}


- (void) nextTouched: (UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    

    NSString *cellphoneValue = self.username.text;
    
    if([cellphoneValue isEqualToString:@""]){
        
        [alert setMessage:@"Please input your phone number."];
        [alert show];
        return;
    }
    

    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"forgetpwd"];
    
    NSDictionary *postData = @{@"cellphone":cellphoneValue};
    
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
            ForgetStep2ViewController *viewController = [[ForgetStep2ViewController alloc] init];
            
            viewController.cellphone = cellphoneValue;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"Network connection timeout."];
        [alert show];
        
        NSLog(@"请求失败");
    }];
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


@end
