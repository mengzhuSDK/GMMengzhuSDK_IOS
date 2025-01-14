//
//  VHPullingRefreshTableView.h
//  VhallIphone
//
//  Created by vhall on 15/8/3.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol VHPullingRefreshTableViewDelegate;


@interface VHPullingRefreshTableView : UITableView
@property (nonatomic) BOOL isHasHead;
@property (nonatomic) BOOL isHasFoot;
@property (nonatomic) BOOL reachedTheEnd;
@property(nonatomic) BOOL  canLoadData;

@property(atomic)NSInteger tag1;//预留参数
@property(atomic)NSInteger tag2;//预留参数
@property(atomic)id        tagID;//预留对象参数

//tabbar是半透明时设置为YES
@property(nonatomic,assign)BOOL showTranpant;

@property(atomic)int  type;//0,粉丝 1，直播 2，关注
@property(atomic)int  startPos;//数据开始位置
@property(atomic)BOOL isFirstUpdate;//数据第一次加载
@property(strong,nonatomic)NSMutableArray* dataArr;//数据
@property (assign,nonatomic) id <VHPullingRefreshTableViewDelegate> pullingDelegate;

-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate;
-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate headView:(BOOL)isHas footView:(BOOL)isHasfoot;
- (void)tableViewDidFinishedLoading;
- (void)launchRefreshing;
@end


@protocol VHPullingRefreshTableViewDelegate<NSObject>

@optional
- (void)pullingTableViewDidStartRefreshing:(VHPullingRefreshTableView *)tableView;//下拉刷新
- (void)pullingTableViewDidStartLoading:(VHPullingRefreshTableView *)tableView;//上拉加载
@end
