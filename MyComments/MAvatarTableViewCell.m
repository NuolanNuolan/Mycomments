//
//  FinanceTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MAvatarTableViewCell.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:16]


@interface MAvatarTableViewCell ()

@end

@implementation MAvatarTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    /*self.imageView.bounds = CGRectMake(10, 10, 30, 30);
     self.imageView.frame = CGRectMake(10, 10, 30, 30);
     self.imageView.contentMode = UIViewContentModeScaleAspectFill;
     */
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 85;
    self.textLabel.frame = tmpFrame;
    
    CGRect vFrame = self.valueLabel.frame;
    vFrame.origin.x = 85;
    self.valueLabel.frame = vFrame;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //self.accessoryType = UITableViewCellAccessoryNone;
    
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    MAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //if (cell == nil) {
    
    cell = [[MAvatarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //}
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        
        UILabel *valueLabel = [[UILabel alloc] init];
        
        self.valueLabel = valueLabel;
        [self.contentView addSubview:valueLabel];
        
        UIImageView *avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [avatarImage.layer setCornerRadius:5.0f];
        self.avatarImage = avatarImage;
        [self.contentView addSubview:avatarImage];
        
        UIButton *avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        
        self.avatarButton = avatarButton;
        [self.contentView addSubview:avatarButton];
        
        UIButton *followButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 85, 20, 70, 25)];
        [followButton setTitle:@"+ Follow" forState:UIControlStateNormal];
        [followButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [followButton.layer setBorderWidth:1.0f];
        [followButton.layer setBorderColor:[BWCommon getRedColor].CGColor];
        [followButton setTitleColor:[BWCommon getRedColor] forState:UIControlStateNormal];
        [followButton.layer setCornerRadius:5.0f];
        self.followButton = followButton;
        
        [self.contentView addSubview:followButton];
        
        
        
        
    }
    
    return self;
}

- (void)setViewFrame:(AvatarTableViewFrame *)viewFrame
{
    _viewFrame = viewFrame;
    
    // 1.给子控件赋值数据
    [self settingData];
    [self settingFrame];
}

/**
 *  设置子控件的数据
 */
- (void)settingData
{
    
    NSDictionary *data = self.viewFrame.data;
    
    NSString *icon = [data objectForKey:@"avatar"];
    
    if([icon isEqualToString:@"noavatar_large"])
    {
        [self.avatarImage setImage:[UIImage imageNamed:icon]];
    }
    else
    {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"noavatar_large"] options:SDWebImageCacheMemoryOnly];
    }
    self.textLabel.text = [data objectForKey:@"title"];
    NSString *UserEmail =[data objectForKey:@"text"];
    if (![UserEmail isEqualToString:@""]) {
        NSInteger length = [UserEmail length];
        NSInteger Action=4;
        NSString *string;
        if (length>Action||length>=8) {
           string= [NSString stringWithFormat:@"%@",[UserEmail stringByReplacingOccurrencesOfString:[UserEmail substringWithRange:NSMakeRange(4,length-8)]withString:@"*******"]];
        }else
        {
        
            string= [NSString stringWithFormat:@"%@",[UserEmail stringByReplacingOccurrencesOfString:[UserEmail substringWithRange:NSMakeRange(4,length-4)]withString:@"*******"]];
        }

        self.valueLabel.text =string;
    }
}

/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.textLabel.frame = self.viewFrame.textF;
    [self.textLabel setTextColor:[BWCommon getRGBColor:0x333333]];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    self.valueLabel.frame = self.viewFrame.valueF;
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    [self.valueLabel setTextColor:[BWCommon getRGBColor:0x999999]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
