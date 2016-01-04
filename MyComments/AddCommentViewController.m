//
//  AddCommentViewController.m
//  MyComments
//
//  Created by Bruce on 15/11/15.
//
//

#import "AddCommentViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"
#import "LDXScore.h"

@interface AddCommentViewController ()

@property (nonatomic,retain) LDXScore *overallRatingStarView;
@property (nonatomic,retain) LDXScore *foodStarView;
@property (nonatomic,retain) LDXScore *environmentStarView;
@property (nonatomic,retain) LDXScore *valueForMoneyStarView;
@property (nonatomic,retain) UITextView *commentView;

@property (nonatomic,retain) UITextField *spendingPerHeadField;

@end

@implementation AddCommentViewController

CGSize size;
UIScrollView *sclView;

UILabel *uilabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pageLayout{
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationItem setTitle:@"Add a Comment"];
    
    
    sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, 780);
    [self.view addSubview:sclView];

    
    self.overallRatingStarView = [self ratingView:@"Overall Rating" paddingY:10];
    
    self.foodStarView = [self ratingView:@"Food" paddingY:40];
    
    self.environmentStarView = [self ratingView:@"Environment" paddingY:70];

    self.valueForMoneyStarView = [self ratingView:@"Value for money" paddingY:100];
    
    UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(15, 150, size.width-30, 120)];
    [sclView addSubview:commentView];
    //commentView.text = @"Content";
    commentView.font = [UIFont systemFontOfSize:14];
    
    commentView.layer.cornerRadius = 5.0f;
    commentView.layer.borderWidth = 1.0f;
    [commentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.commentView = commentView;
    commentView.delegate = self;
    [commentView setBackgroundColor:[UIColor whiteColor]];
    
    uilabel = [[UILabel alloc] init];
    uilabel.frame =CGRectMake(20, 155, self.view.bounds.size.width - 30, 20);
    uilabel.text = @"Content";
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    
    [sclView addSubview:commentView];
    [sclView addSubview:uilabel];
    
    UITextField *spendingPerHead = [self createTextField:@"" Title:@"Spending per Head"];
    spendingPerHead.frame = CGRectMake(15,300,size.width-30,50);
    [sclView addSubview:spendingPerHead];
    spendingPerHead.delegate = self;
    self.spendingPerHeadField = spendingPerHead;
    [sclView addSubview:spendingPerHead];
    
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSubmit.frame = CGRectMake(15 , 370, size.width-30, 50);
    [btnSubmit.layer setMasksToBounds:YES];
    [btnSubmit.layer setCornerRadius:5.0];
    btnSubmit.backgroundColor =[BWCommon getRGBColor:0x62c462];
    btnSubmit.tintColor = [UIColor whiteColor];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:22];
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnSubmit];
    

}

-(void) submitTouched:(UIButton *) sender{
    
}

- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    //UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    //icon.frame = CGRectMake(20, 10, 30, 20);
    //field.leftView = icon;
    //field.leftViewMode = UITextFieldViewModeAlways;
    //field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}


-(void)textViewDidChange:(UITextView *)textView
{
    //self.examineText =  textView.text;
    if (textView.text.length == 0) {
        uilabel.text = @"Content";
    }else{
        uilabel.text = @"";
    }
}

-(LDXScore *) ratingView: (NSString *) title paddingY:(CGFloat) paddingY{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,paddingY+10,120,30)];
    [sclView addSubview:titleLabel];
    [titleLabel setText:title];
    [titleLabel setFont: [UIFont systemFontOfSize:14]];
    [titleLabel setTextAlignment:NSTextAlignmentRight];
    
    LDXScore *starView = [[LDXScore alloc] initWithFrame:CGRectMake(140,paddingY,140,50)];
    starView.normalImg = [UIImage imageNamed:@"btn_star_evaluation_normal"];
    starView.highlightImg = [UIImage imageNamed:@"btn_star_evaluation_press"];
    starView.isSelect = YES;
    starView.padding = 0;
    starView.layer.cornerRadius = 10;
    starView.layer.masksToBounds = YES;
    
    [sclView addSubview:starView];
    return starView;
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
