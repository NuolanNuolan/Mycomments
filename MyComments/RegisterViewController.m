//
//  RegisterViewController.m
//  MyComments
//
//  Created by Bruce on 15-9-10.
//
//

#import "RegisterViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "Register2ViewController.h"
#import "TermsViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

UITextField *username;

BOOL agreed = YES;

CGSize size;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
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
    [self.navigationItem setTitle:@"Register"];
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width, 30)];
    [tipsLabel setText:@"Your password will be sent to your cell phone."];
    
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
    
    UISwitch *agree = [[UISwitch alloc] initWithFrame:CGRectMake(15, 130, 80, 50)];
    
    [agree setOn:YES];
    [agree addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [sclView addSubview:agree];
    
    //UILabel *agreeTips = [[UILabel alloc] initWithFrame:CGRectMake(70, 115, size.width-85, 20)];
    //[agreeTips setText:@"Agree terms and condition."];
    //[agreeTips setTextColor:[BWCommon getRGBColor:0x888888]];
    //[sclView addSubview:agreeTips];
    
    UIButton *btnAgreeTips = [[UIButton alloc] initWithFrame:CGRectMake(70, 135, size.width-85, 20)];
    [btnAgreeTips setTitle:@"Agree terms and condition." forState:UIControlStateNormal];
    [btnAgreeTips setTitleColor:[BWCommon getRGBColor:0x888888] forState:UIControlStateNormal];
    [btnAgreeTips.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [sclView addSubview:btnAgreeTips];
    
    [btnAgreeTips addTarget:self action:@selector(termsTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnNext.frame = CGRectMake(15 , 180, size.width-30, 50);
    [btnNext.layer setMasksToBounds:YES];
    [btnNext.layer setCornerRadius:5.0];
    btnNext.backgroundColor =[BWCommon getRGBColor:0xff0000];
    btnNext.tintColor = [UIColor whiteColor];
    btnNext.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnNext setTitle:@"Next step" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(nextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnNext];
    
    //email address admin@mycomments.com.my
    
    UILabel *labelEmail = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height * 0.8, size.width, 20)];
    
    [labelEmail setText:@"admin@mycomments.com.my"];
    [labelEmail setFont:[UIFont systemFontOfSize:14]];
    [labelEmail setTextAlignment:NSTextAlignmentCenter];
    [labelEmail setTextColor:[BWCommon getRGBColor:0x666666]];
    [sclView addSubview:labelEmail];


}
- (void) termsTouched: (UIButton *) sender{
    
    TermsViewController*termsVC=[[TermsViewController alloc]init];
   
    [self.navigationController pushViewController:termsVC animated:YES];
}

- (void) nextTouched: (UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if(!agreed){
        
        [alert setMessage:@"Please agree terms and condition."];
        [alert show];
        return;
    }
    
    NSString *cellphoneValue = username.text;
    
    if([cellphoneValue isEqualToString:@""]){
        
        [alert setMessage:@"Please input your phone number."];
        [alert show];
        return;
    }

    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addUser"];
    
    NSDictionary *postData = @{@"cellphone":cellphoneValue};
    
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
            Register2ViewController *viewController = [[Register2ViewController alloc] init];
            
            viewController.cellphone = cellphoneValue;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"Network connection timeout."];
        [alert show];
        
        MYLOG(@"请求失败");
    }];
}

- (void) switchAction:(id)sender{
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        agreed=YES;
        //showSwitchValue.text = @"是";
    }else {
        agreed=NO;
        //showSwitchValue.text = @"否";
    }
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
