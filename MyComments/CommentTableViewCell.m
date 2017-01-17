//
//  CommentTableViewCell.m
//  MyComments
//
//  Created by Bruce He on 15/7/3.
//
//

#import "CommentTableViewCell.h"
#import "CommentTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@interface CommentTableViewCell ()

// 名称
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *usernameLabel;
@property (nonatomic, weak) UILabel *commentLabel;

@property (nonatomic,weak) UIImageView *rateView;

@property (nonatomic,weak) UIImageView *avatarView;

@end

@implementation CommentTableViewCell

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
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = NJTextFont;
        commentLabel.numberOfLines = 0;
        //orderFeeLabel.textColor = [UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1];
        
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        
        UILabel *usernameLabel = [[UILabel alloc] init];
        usernameLabel.font = NJTextFont;
        usernameLabel.numberOfLines = 0;
        //usernameLabel.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
        self.usernameLabel = usernameLabel;
        usernameLabel.textColor = [BWCommon getRGBColor:0x666666];
        
        [self.contentView addSubview:usernameLabel];
        
        
        UIImageView *avatarView = [[UIImageView alloc] init];
        self.avatarView = avatarView;
        [avatarView.layer setCornerRadius:5.0f];
        
        
        [self.contentView addSubview:avatarView];
        
        UIImageView *rateView = [[UIImageView alloc] init];
        self.rateView = rateView;
        [self.contentView addSubview:rateView];
        
        UIButton *memberButton = [[UIButton alloc] init];
        self.memberButton = memberButton;
        [self.contentView addSubview:memberButton];
        
        
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

- (void)setViewFrame:(CommentTableViewFrame *)viewFrame
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
    
    NSString *image_url = [data objectForKey:@"shop_small_image"];
    
    image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@!m90x90.jpg",[BWCommon getBaseInfo:@"site_url"],image_url ];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"appicon.png"] options:SDWebImageCacheMemoryOnly];
    
    self.nameLabel.text = [data objectForKey:@"shop_name"];
    self.commentLabel.text = [data objectForKey:@"detail"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"RM %@",[data objectForKey:@"price"]];
    self.usernameLabel.text = [data objectForKey:@"username"];
    
    NSString *avatar_url = [data objectForKey:@"avatar"];
    avatar_url = [NSString stringWithFormat:@"%@/%@",[BWCommon getBaseInfo:@"site_url"],avatar_url];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatar_url] placeholderImage:[UIImage imageNamed:@"noavatar_small.png"] options:SDWebImageCacheMemoryOnly];
    
    
    NSString *rateImage = [NSString stringWithFormat:@"comment_star_%@.png",[data objectForKey:@"rate"] ];
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
    self.priceLabel.frame = self.viewFrame.priceF;
    self.avatarView.frame = self.viewFrame.avatarF;
    self.rateView.frame = self.viewFrame.rateF;
    self.commentLabel.frame = self.viewFrame.commentF;
    self.usernameLabel.frame = self.viewFrame.usernameF;
    
    self.memberButton.frame = self.viewFrame.avatarF;
}


@end
