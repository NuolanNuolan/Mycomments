//
//  ShopTableViewCell.m
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import "ShopTableViewCell.h"
#import "ShopTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface ShopTableViewCell ()

// 名称
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *tagLabel;
@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic,weak) UIImageView *rateView;


@end

@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 90, 90 );
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[ShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NJNameFont;
        nameLabel.numberOfLines = 0;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = NJTextFont;
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = NJTextFont;
        tagLabel.numberOfLines = 0;
        tagLabel.textColor = [BWCommon getRGBColor:0x666666];

        [self.contentView addSubview:tagLabel];
        self.tagLabel = tagLabel;
        
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.font = NJTextFont;
        //distanceLabel.numberOfLines = 0;
        //usernameLabel.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
        self.distanceLabel = distanceLabel;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        distanceLabel.textColor = [BWCommon getRGBColor:0x666666];
        
        [self.contentView addSubview:distanceLabel];
        
             
        UIImageView *rateView = [[UIImageView alloc] init];
        self.rateView = rateView;
        [self.contentView addSubview:rateView];
        
        
    }
    return self;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (void)setViewFrame:(ShopTableViewFrame *)viewFrame
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
    
    NSString *image_url = [data objectForKey:@"small_image"];
    
    if(!image_url)
        image_url = [data objectForKey:@"image"];
    
    MYLOG(@"%@",image_url);
    
    image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@!m90x90.jpg",[BWCommon getBaseInfo:@"site_url"],image_url ];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"appicon.png"]];
    
    if([[data objectForKey:@"is_closed"] isEqualToString:@"1"])
    {
        UIImageView *closedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closed"]];
        closedImage.frame = CGRectMake(0, 0, 100, 78);
        [self.imageView addSubview:closedImage];
    }
    
    
    self.nameLabel.text = [data objectForKey:@"name"];
    self.tagLabel.text = [data objectForKey:@"tags"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"RM %@",[data objectForKey:@"price"]];
    
    CGFloat distance = [[data objectForKey:@"distance"] floatValue];
    
    if(distance > 0){
        self.distanceLabel.text = [self formatDistance:distance];
    }
    
    int rate = [[data objectForKey:@"rate"] intValue];
    
    NSString *rateImage = [NSString stringWithFormat:@"comment_star_%d",rate ];
    [self.rateView setImage:[UIImage imageNamed:rateImage]];
}

- (NSString *) formatDistance:(CGFloat)distance{
    NSString * str;
    if(distance > 1000){
        
        str = [NSString stringWithFormat:@"%.1f km",(distance / 1000) ];
    }
    else if(distance<=1000&&distance>500)
    {
        str = [NSString stringWithFormat:@"<1km"];
    }else if (distance<=500&&distance>100)
    {
    
        str = [NSString stringWithFormat:@"<500m"];
        
    }else if (distance<=200)
    {
    
         str = [NSString stringWithFormat:@"<200m"];
        
    }
    return str;
}

/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.layer.borderWidth=1.0;
    
    self.nameLabel.frame = self.viewFrame.nameF;
    self.priceLabel.frame = self.viewFrame.priceF;

    self.rateView.frame = self.viewFrame.rateF;
    self.tagLabel.frame = self.viewFrame.tagF;
    self.distanceLabel.frame = self.viewFrame.distanceF;
    
}


@end
