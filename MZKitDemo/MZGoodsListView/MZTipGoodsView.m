//
//  MZTipGoodsView.m
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZTipGoodsView.h"

@interface MZTipGoodsView ()
@property (nonatomic ,strong)UIImageView *coverImageView;
@property (nonatomic ,strong)UILabel *goodsTitleL;
@property (nonatomic ,strong)UILabel *priceL;
@end
@implementation MZTipGoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.autoresizesSubviews = YES;
    }
    return self;
}

-(void)setupUI
{
    [self roundChangeWithRadius:4*MZ_RATE];
    self.backgroundColor = MakeColorRGB(0xffffff);
    self.autoresizesSubviews = YES;
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*MZ_RATE, 60*MZ_RATE)];
    [self addSubview:self.coverImageView];
    [self setSubViewAutoresizingMask:self.coverImageView];
    
    self.goodsTitleL = [[UILabel alloc]initWithFrame:CGRectMake(self.coverImageView.right + 8*MZ_RATE, 8*MZ_RATE, 98*MZ_RATE, 20*MZ_RATE)];
    self.goodsTitleL.font = FontSystemSize(14*MZ_RATE);
    self.goodsTitleL.textColor = MakeColorRGB(0x333333);
    [self addSubview:self.goodsTitleL];
    [self setSubViewAutoresizingMask:self.goodsTitleL];
    
    self.priceL = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsTitleL.left, self.goodsTitleL.bottom + 2*MZ_RATE, 98*MZ_RATE, 20*MZ_RATE)];
    self.priceL.font = FontSystemSize(14*MZ_RATE);
    self.priceL.textColor = MakeColorRGB(0xff4141);
    [self addSubview:self.priceL];
    [self setSubViewAutoresizingMask:self.priceL];
}

-(void)setSubViewAutoresizingMask:(UIView *)view
{
    view.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin   |
    UIViewAutoresizingFlexibleWidth        |
    UIViewAutoresizingFlexibleRightMargin  |
    UIViewAutoresizingFlexibleTopMargin    |
    UIViewAutoresizingFlexibleHeight       |
    UIViewAutoresizingFlexibleBottomMargin ;
}


-(void)setGoodsListModelArr:(NSMutableArray *)goodsListModelArr
{
    _goodsListModelArr = goodsListModelArr;
}


-(void)showGoodsViewWithModel:(MZGoodsListModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:MZ_GoodsPlaceHolder];
    self.goodsTitleL.text = model.name;
    self.priceL.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.frame = CGRectMake(self.left, self.top, 1, 1);
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.left, self.top, 185*MZ_RATE, 60*MZ_RATE);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(self.left, self.top, 185*MZ_RATE, 60*MZ_RATE);
        self.alpha = 1;
        [self keepShowTheGoodsView];
    }];
}

-(void)hiddenGoodViewWithModel:(MZGoodsListModel *)model
{
    self.frame = CGRectMake(self.left, self.top, 185*MZ_RATE, 60*MZ_RATE);
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.left, self.top, 1, 1);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(self.left, self.top, 1, 1);
        self.alpha = 0;
        [self.goodsListModelArr removeObjectAtIndex:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self beginAnimation];
        });
        
        
    }];
}

-(void)keepShowTheGoodsView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenGoodViewWithModel:self.goodsListModelArr[0]];
    });
}

-(void)beginAnimation;//开启动画
{
    if(self.goodsListModelArr.count > 0){
        [self showGoodsViewWithModel:self.goodsListModelArr[0]];
    }
}
-(void)stopAnimation;//关闭动画
{
    
}

@end
