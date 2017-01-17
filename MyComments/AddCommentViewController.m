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
@property (nonatomic,retain) UILabel *commentNumberLabel;

@property (nonatomic,retain) NSArray *tagList;
@property (nonatomic,retain) NSMutableArray *tagButtonList;

@property (nonatomic,retain) UITextField *spendingPerHeadField;

#define LIMIT_SME_LEN = 500;

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
    
    UILabel *commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width-100, 270, 80, 20)];
    self.commentNumberLabel = commentNumberLabel;
    [commentNumberLabel setFont:[UIFont systemFontOfSize:14]];
    [commentNumberLabel setTextColor:[UIColor grayColor]];
    [commentNumberLabel setTextAlignment:NSTextAlignmentRight];
    
    [sclView addSubview:commentNumberLabel];
    
    UITextField *spendingPerHead = [self createTextField:@"" Title:@"Spending per Head"];
    spendingPerHead.frame = CGRectMake(15,300,size.width-30,50);
    [sclView addSubview:spendingPerHead];
    spendingPerHead.delegate = self;
    self.spendingPerHeadField = spendingPerHead;
    [sclView addSubview:spendingPerHead];
    
    NSArray *tagList = [[NSArray alloc] initWithObjects:@"Good food",@"Family dinning",@"Business dinning",@"Dating",@"Friends gathering",@"Wedding",@"Easy parking",@"Reasonable price",@"Quick bite",@"Breakfast",@"Lunch",@"Dinner",@"High Tea",@"Supper",@"All Day", nil];
    
    self.tagList = tagList;
    
    self.tagButtonList = [[NSMutableArray alloc] initWithCapacity:[tagList count]];
    
    int _tagX=10;
    int _tagY=320;
    int _tagW= size.width / 2 - 20;
    int _tagH = 30;
    for(int i=0;i<[tagList count];i++){
        _tagX = i % 2 * (_tagW+10) + 10;
        if(i % 2==0)
        {
            _tagY+=_tagH + 10;
        }
        
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(_tagX, _tagY, _tagW, _tagH)];
        [tagButton setTitle:tagList[i] forState:UIControlStateNormal];
        [tagButton.layer setBorderWidth:1.0f];
        [tagButton setTitleColor:[BWCommon getRGBColor:0x666666] forState:UIControlStateNormal];
        [tagButton setTitleColor:[BWCommon getRedColor] forState:UIControlStateSelected];
        [tagButton.layer setBorderColor:[BWCommon getRGBColor:0xdddddd].CGColor];
        [tagButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [tagButton setBackgroundColor:[BWCommon getRGBColor:0xffffff]];
        tagButton.tag = i;
        [tagButton addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [sclView addSubview:tagButton];
        
        self.tagButtonList[i] = tagButton;
        
        
    }
    
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSubmit.frame = CGRectMake(15 , _tagY + 60, size.width-30, 50);
    [btnSubmit.layer setMasksToBounds:YES];
    [btnSubmit.layer setCornerRadius:5.0];
    btnSubmit.backgroundColor =[BWCommon getRGBColor:0x62c462];
    btnSubmit.tintColor = [UIColor whiteColor];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:22];
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnSubmit];
    

    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    
}

-(void) tagButtonTouched:(UIButton *)sender{
    sender.selected = !sender.selected;
}
// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}

-(void) submitTouched:(UIButton *) sender{
    
    //MYLOG(@"%ld",self.overallRatingStarView.show_star);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    NSMutableArray *selectedTags = [[NSMutableArray alloc] init];
    for(int i=0;i<[self.tagButtonList count];i++){
        UIButton *btn = self.tagButtonList[i];
        if(btn.selected){
            [selectedTags addObject:self.tagList[btn.tag]];
        }
    }
    NSString *tags = [selectedTags componentsJoinedByString:@","];
    //MYLOG(@"%@",tags);
    //return;
    
    NSString *commentText = self.commentView.text;
    if(commentText.length<120){
        [alert setMessage:[NSString stringWithFormat:@"You still have to type %lu more characters.",120-commentText.length]];
        [alert show];
        return;
    }else if (commentText.length>500){
        [alert setMessage:[NSString stringWithFormat:@"Over %lu characters.",commentText.length-500]];
        [alert show];
        return;
    }
    //return;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addComment"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",(long)self.overallRatingStarView.show_star] forKey:@"rate"];
    [postData setValue:[NSString stringWithFormat:@"%ld",(long)self.foodStarView.show_star] forKey:@"rate1"];
    [postData setValue:[NSString stringWithFormat:@"%ld",(long)self.environmentStarView.show_star] forKey:@"rate2"];
    [postData setValue:[NSString stringWithFormat:@"%ld",(long)self.valueForMoneyStarView.show_star] forKey:@"rate3"];
    [postData setValue:tags forKey:@"tags"];
    
    //[alert setMessage:[NSString stringWithFormat:@"%ld",(long)self.valueForMoneyStarView.show_star]];
    //[alert show];
    //return;
    //5分不行！！！！！！
    /*[postData setValue:self.name.text forKey:@"name"];
    [postData setValue:[NSString stringWithFormat:@"%ld",cid] forKey:@"cid"];
    [postData setValue:[NSString stringWithFormat:@"%ld",region_id] forKey:@"region_id"];
    [postData setValue:self.openingTime.text forKey:@"opening_hours"];
    [postData setValue:self.tel.text forKey:@"tel"];*/
    [postData setValue:self.spendingPerHeadField.text forKey:@"price"];
    [postData setValue:commentText forKey:@"detail"];

    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.sid] forKey:@"sid"];
    
    
    
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
            [alert setMessage:@"Add Comment successfully."];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"Network connection timeout."];
        [alert show];
        
        MYLOG(@"请求失败");
    }];
    
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
    
    NSInteger commentLength = [textView.text length];
    
    if(commentLength<120 || commentLength > 500){
        [self.commentNumberLabel setTextColor:[UIColor redColor]];
    }else{
        [self.commentNumberLabel setTextColor:[UIColor greenColor]];
    }
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%lu/%d", commentLength, 500];
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 500) {
        return NO;
    }
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
