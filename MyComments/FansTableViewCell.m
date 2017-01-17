//
//  ShopTableViewCell.m
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import "FansTableViewCell.h"
#import "FansTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface FansTableViewCell ()

// 名称
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic,weak) UIImageView *rateView;


@end

@implementation FansTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 50, 50 );
    [self.imageView.layer setCornerRadius:5.0f];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.font = NJTextFont;
        introLabel.numberOfLines = 0;
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;

        
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

- (void)setViewFrame:(FansTableViewFrame *)viewFrame
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
    
    NSString *image_url = [data objectForKey:@"avatar_small"];
    
    image_url = [NSString stringWithFormat:@"%@%@",[BWCommon getBaseInfo:@"site_url"],image_url ];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"noavatar_large"] options:SDWebImageCacheMemoryOnly];

    
    if(![[data objectForKey:@"intro"] isEqual:[NSNull null] ] ){
        NSString *introText = [data objectForKey:@"intro"];
        
        self.introLabel.text = introText;
    }
    self.nameLabel.text = [data objectForKey:@"username"];
    
    
    
    int rate = [[data objectForKey:@"level"] intValue];
    
    NSString *rateImage = [NSString stringWithFormat:@"grade_%d.png",rate ];
    [self.rateView setImage:[UIImage imageNamed:rateImage]];
}



/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.layer.borderWidth=1.0;
    
    self.nameLabel.frame = self.viewFrame.nameF;
    
    self.rateView.frame = self.viewFrame.rateF;
    
    self.introLabel.frame = self.viewFrame.introF;
    
}


@end
