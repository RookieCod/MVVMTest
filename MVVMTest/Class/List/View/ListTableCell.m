//
//  ListTableCell.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/11.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListTableCell.h"

@interface ListTableCell ()
/**
 * <#注释#>
 */
@property (nonatomic, strong) UIImageView *leftImage;
/**
 * <#注释#>
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * <#注释#>
 */
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation ListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        [RACObserve(self, listModel) subscribeNext:^(ListModel *listModel) {
            @strongify(self);
            [self.leftImage sd_setImageWithURL:[NSURL URLWithString:_listModel.imageUrl] placeholderImage:nil];
//            self.titleLabel.text = _listModel.titleName;
//            self.descLabel.text = _listModel.desc;
        }];
        RAC(self.titleLabel,text) = RACObserve(self, listModel.titleName);
        RAC(self.descLabel,text) = RACObserve(self, listModel.desc);
        [self zs_setupViews];
        

    }
    return self;
}

- (void)zs_setupViews{
    [self.contentView addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.leftImage.mas_right).offset(20);
    }];
    
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
}

- (UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
    }
    return _leftImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}

//- (void)setListModel:(ListModel *)listModel
//{
//    if (!listModel) {
//        return;
//    }
//    _listModel = listModel;
//    
//    
//}

+ (CGFloat)cellHeight:(ListModel *)listModel
{
    //获取name和desc的高度
    CGFloat nameHeight = [listModel.titleName boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    CGFloat descHeight = [listModel.desc boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat height2 = 10 + nameHeight + 10 + descHeight + 10;
    return height2 + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
