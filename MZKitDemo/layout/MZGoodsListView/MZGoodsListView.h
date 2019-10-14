//
//  MZGoodsListView.h
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^GoodsListViewCellClickBlock)(MZGoodsListModel *model);
typedef void(^GoodsDataResult)(MZGoodsListOuterModel *model);

@protocol MZGoodsRequestProtocol <NSObject>
-(void)requestGoodsList:(GoodsDataResult) block offset:(int)offset;
@end
@interface MZGoodsListView : UIView
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic,assign) int totalNum;
@property (nonatomic,assign)int offset;
@property (nonatomic,strong)id<MZGoodsRequestProtocol> requestDelegate;
@property (nonatomic,copy) GoodsListViewCellClickBlock goodsListViewCellClickBlock;
@end

NS_ASSUME_NONNULL_END
