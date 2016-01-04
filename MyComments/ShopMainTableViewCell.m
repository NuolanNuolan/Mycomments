//
//  ShopMainTableViewCell.m
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import "ShopMainTableViewCell.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface ShopMainTableViewCell()

@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *priceLabel;

@property (nonatomic,weak) UIImageView *rateView;
@property (nonatomic,weak) UIView *rate1View;
@property (nonatomic,weak) UIView *rate2View;
@property (nonatomic,weak) UIView *rate3View;
@property (nonatomic,weak) UILabel *rate1Label;
@property (nonatomic,weak) UILabel *rate2Label;
@property (nonatomic,weak) UILabel *rate3Label;

@property (nonatomic,weak) UIImageView *halaView;
@property (nonatomic,weak) UIImageView *wifiView;
@property (nonatomic,weak) UIImageView *psView;

@end

@implementation ShopMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    //self.imageView.frame = CGRectMake(10, 10, 90, 90 );
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    ShopMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[ShopMainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = NJNameFont;
        [self.contentView addSubview:nameLabel];
        
        UIImageView *mainImage = [[UIImageView alloc] init];
        self.mainImage = mainImage;
        [self.contentView addSubview:mainImage];
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        [imageButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [imageButton setTitleColor:[BWCommon getRGBColor:0x333333] forState:UIControlStateNormal];
        imageButton.layer.cornerRadius = 10.0f;
        [imageButton setBackgroundColor:[UIColor whiteColor]];
        [imageButton setAlpha:0.6f];
        
        self.imageButton = imageButton;
        
        [self.contentView addSubview:imageButton];
        
        
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        priceLabel.font = NJTextFont;
        [self.contentView addSubview:priceLabel];
        
        UIImageView *rateView = [[UIImageView alloc] init];
        self.rateView = rateView;
        [self.contentView addSubview:rateView];
        
        UIView *rate1View = [self createRateView:@"Food"];
        self.rate1View = rate1View;
        [self.contentView addSubview:rate1View];
        
        UILabel *rate1Label = [self createRateValue];
        self.rate1Label = rate1Label;
        [rate1View addSubview:rate1Label];

        UIView *rate2View = [self createRateView:@"Enviroment"];
        self.rate2View = rate2View;
        [self.contentView addSubview:rate2View];
        
        UILabel *rate2Label = [self createRateValue];
        self.rate2Label = rate2Label;
        [rate2View addSubview:rate2Label];
        
        
        UIView *rate3View = [self createRateView:@"Value for money"];
        self.rate3View = rate3View;
        [self.contentView addSubview:rate3View];
        
        UILabel *rate3Label = [self createRateValue];
        self.rate3Label = rate3Label;
        [rate3View addSubview:rate3Label];
        
        UIImageView *halaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qz.gif"]];
        self.halaView = halaView;
        [self.contentView addSubview:halaView];
        
        UIImageView *wifiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi.gif"]];
        self.wifiView = wifiView;
        [self.contentView addSubview:wifiView];
        
        UIImageView *psView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ps.gif"]];
        self.psView = psView;
        [self.contentView addSubview:psView];
    }
    return self;
}

- (UIView *) createRateView:(NSString *) title{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rate_bg.png"]]];
    [view addSubview:[self createRateTitle:title]];
    
    return view;
}

- (UILabel *)createRateTitle:(NSString *) title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
    titleLabel.font = NJTextFont;
    titleLabel.text = title;
    return titleLabel;
}

- (UILabel *)createRateValue{
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 50, 16)];
    valueLabel.font = NJTextFont;
    valueLabel.textColor = [BWCommon getRedColor];
    return valueLabel;
}

- (void)setViewFrame:(ShopMainTableViewFrame *)viewFrame
{
    _viewFrame = viewFrame;
    
    // 1.给子控件赋值数据
    [self settingData];
    // 2.设置frame
    [self settingFrame];
}


/**
 *  设置子控件的数据
 */
- (void)settingData
{
    
    NSDictionary *data = self.viewFrame.data;
    
    if ([data count] <=0) return;
    
    NSString *image_url = [data objectForKey:@"small_image"];
    
    image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@!m125x90.jpg",[BWCommon getBaseInfo:@"site_url"],image_url ];
    
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"appicon.png"] options:SDWebImageCacheMemoryOnly];
    
    //[imageButton setBackgroundColor:[UIColor clearColor]];
    [self.imageButton setTitle:[data objectForKey:@"photo_number"] forState:UIControlStateNormal];
    self.imageButton.tag = [[data objectForKey:@"sid"] integerValue];
    
    self.nameLabel.text = [data objectForKey:@"name"];
    
    NSInteger rate = [[data objectForKey:@"rate"] integerValue];
    
    [self.rateView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"comment_star_%ld.png",rate]]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"RM %@",[data objectForKey:@"price"] ];
    
    self.rate1Label.text = [data objectForKey:@"rate1"];
    self.rate2Label.text = [data objectForKey:@"rate2"];
    self.rate3Label.text = [data objectForKey:@"rate3"];
}

- (void) settingFrame
{

    self.nameLabel.frame = self.viewFrame.nameF;
    self.mainImage.frame = self.viewFrame.imageF;
    self.imageButton.frame = self.viewFrame.imageNumF;
    self.rateView.frame = self.viewFrame.rateF;
    self.priceLabel.frame = self.viewFrame.priceF;
    self.rate1View.frame = self.viewFrame.rate1F;
    self.rate2View.frame = self.viewFrame.rate2F;
    self.rate3View.frame = self.viewFrame.rate3F;
    self.halaView.frame = self.viewFrame.halaF;
    self.psView.frame = self.viewFrame.psF;
    self.wifiView.frame = self.viewFrame.wifiF;

}

@end
