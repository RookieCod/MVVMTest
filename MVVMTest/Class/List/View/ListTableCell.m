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
+ (ListTableCell *)tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier
{
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        @weakify(self);
//        [RACObserve(self, listModel) subscribeNext:^(ListModel *listModel) {
//            @strongify(self);
//            [self.leftImage sd_setImageWithURL:[NSURL URLWithString:_listModel.imageUrl] placeholderImage:nil];
////            self.titleLabel.text = _listModel.titleName;
////            self.descLabel.text = _listModel.desc;
//        }];
//        RAC(self.titleLabel,text) = RACObserve(self, listModel.titleName);
//        RAC(self.descLabel,text) = RACObserve(self, listModel.desc);
        [self zs_setupViews];
        [self addContraints];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
}
- (void)zs_setupViews{
    [self.contentView addSubview:self.leftImage];
    
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.descLabel];
    
}

- (void)addContraints
{
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(145);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.leftImage.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.bottom.right.equalTo(self.contentView).offset(-10);
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
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
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


- (void)configViewsWithModel:(ListModel *)model 
{
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    self.descLabel.text = model.author_intro;
    if (!model.author_intro || [model.author_intro isEqualToString:@""]) {
        [self.leftImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(145);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    } else {
        [self.leftImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(145);
        }];
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel);
            make.bottom.right.equalTo(self.contentView).offset(-10);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
