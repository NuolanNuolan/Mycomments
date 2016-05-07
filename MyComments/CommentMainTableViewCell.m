//
//  CommentMainTableViewCell.m
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//


#import "CommentMainTableViewCell.h"
#import "CommentMainTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@interface CommentMainTableViewCell ()

// 名称
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic,weak) UIImageView *avatarImage;

@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *usernameLabel;
@property (nonatomic, weak) UILabel *commentLabel;

@property (nonatomic,weak) UIImageView *rateView;

@property (nonatomic,weak) UILabel *dateLabel;





@end

@implementation CommentMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    //CGRect rect;
    /*if(self.hasName)
        rect = CGRectMake(10, 40, 50, 50);
    else
        rect = CGRectMake(10, 14, 50, 50);

    self.imageView.frame = rect;*/
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell2";
    CommentMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[CommentMainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        
        UIImageView *avatarImage = [[UIImageView alloc] init];
        self.avatarImage = avatarImage;
        [self.contentView addSubview:avatarImage];
        
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
        usernameLabel.textColor = [BWCommon getRGBColor:0x666666];
        usernameLabel.numberOfLines = 0;
        //usernameLabel.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
        self.usernameLabel = usernameLabel;
        
        [self.contentView addSubview:usernameLabel];
        
    
        UIImageView *rateView = [[UIImageView alloc] init];
        self.rateView = rateView;
        [self.contentView addSubview:rateView];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = NJTextFont;
        dateLabel.textColor = [BWCommon getRGBColor:0x999999];
        self.dateLabel = dateLabel;

        [self.contentView addSubview:dateLabel];
        
        
        UIButton *likeButton = [[UIButton alloc] init];
        self.likeButton = likeButton;
        [self.contentView addSubview:likeButton];
        
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good"]];
        [likeButton addSubview:likeIcon];
        likeButton.titleLabel.font = NJTextFont;
        [likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
    }
    return self;
}


- (void)setViewFrame:(CommentMainTableViewFrame *)viewFrame
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
    
    /*
    NSString *image_url = [data objectForKey:@"shop_small_image"];
    
    image_url = [NSString stringWithFormat:@"%@/uploadfiles/%@!m90x90.jpg",[BWCommon getBaseInfo:@"site_url"],image_url ];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"appicon.png"] options:SDWebImageCacheMemoryOnly];
     */
    
    self.nameLabel.text = [data objectForKey:@"shop_name"];
    self.commentLabel.text = [data objectForKey:@"detail"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"Spending per person: RM %@",[data objectForKey:@"price"]];
    self.usernameLabel.text = [data objectForKey:@"username"];
    
    NSString *avatar_url = [data objectForKey:@"avatar"];
    avatar_url = [NSString stringWithFormat:@"%@/%@",[BWCommon getBaseInfo:@"site_url"],avatar_url];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:avatar_url] placeholderImage:[UIImage imageNamed:@"noavatar_small.png"] options:SDWebImageCacheMemoryOnly];
    
    NSInteger rate = [[data objectForKey:@"rate"] integerValue];
    
    NSString *rateImage = [NSString stringWithFormat:@"comment_star_%ld.png",rate];
    [self.rateView setImage:[UIImage imageNamed:rateImage]];
    
    self.dateLabel.text = [data objectForKey:@"created_time"];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"(%@)",[data objectForKey:@"likeit_number"]] forState:UIControlStateNormal];
    
    NSInteger cid =[[data objectForKey:@"id"] integerValue];
    if(!cid){
        cid = [[data objectForKey:@"cid"] integerValue];
    }
    self.likeButton.tag = cid;
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.layer.borderWidth=1.0;
    
    self.avatarImage.frame = self.viewFrame.avatarF;
    self.nameLabel.frame = self.viewFrame.nameF;
    self.priceLabel.frame = self.viewFrame.priceF;
    self.rateView.frame = self.viewFrame.rateF;
    self.commentLabel.frame = self.viewFrame.commentF;
    self.usernameLabel.frame = self.viewFrame.usernameF;
    self.dateLabel.frame = self.viewFrame.dateF;
    self.likeButton.frame = self.viewFrame.likeF;
    
}



@end