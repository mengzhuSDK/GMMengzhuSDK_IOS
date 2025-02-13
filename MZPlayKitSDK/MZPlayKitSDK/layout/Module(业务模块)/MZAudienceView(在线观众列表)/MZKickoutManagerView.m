//
//  MZKickoutManagerView.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/17.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZKickoutManagerView.h"
#import "MZAudienceCell.h"

@interface MZKickoutManagerView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property (nonatomic, strong) UITableView *tableView;//tableView
@property (nonatomic,   copy) NSString *chatIdOfMe;

@property (nonatomic,   copy) NSString *channel_id;//频道ID
@property (nonatomic,   copy) NSString *ticket_id;//活动凭证ID
@end

@implementation MZKickoutManagerView

- (void)dealloc {
    NSLog(@"踢出管理列表释放");
}

- (instancetype)initWithFrame:(CGRect)frame ticket_id:(NSString *)ticket_id channel_id:(NSString *)channel_id chatIdOfMe:(NSString *)chatIdOfMe {
    self = [super initWithFrame:frame];
    if (self) {
        self.ticket_id = ticket_id;
        self.channel_id = channel_id;
        self.chatIdOfMe = chatIdOfMe;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        CGFloat bottomView = IPHONE_X ? 34.0 : 0;

        UIView* footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, bottomView)];
        _tableView.tableFooterView= footview;
        
        [self addSubview:_tableView];
        
        WeaklySelf(weakSelf);

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:NO];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:YES];
        }];
        
        [self loadDataIsMore:NO];
    }
    return self;
}

- (void)unKickoutButtonClick:(UIButton *)sender {
    MZOnlineUserListModel *model = self.dataArray[sender.tag];
    
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager kickoutUserWithTicketId:self.ticket_id channelId:self.channel_id uid:model.uid isKickout:NO success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:@"解除踢出成功"];
        [self.dataArray removeObjectAtIndex:sender.tag];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZOnlineUserListModel * model = self.dataArray[indexPath.row];
    static NSString * identifier = @"MZAudienceCell_kickout";
    MZAudienceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZAudienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:model type:1 chatIdOfMe:self.chatIdOfMe isLiveHost:YES];
    cell.unKickoutButton.tag = indexPath.row;
    [cell.unKickoutButton addTarget:self action:@selector(unKickoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    // 这里是回调到父类点击了用户信息，暂时没用，注销掉
//    MZOnlineUserListModel *model = self.dataArray[indexPath.row];
//    if (self.selectUserHandle) {
//        self.selectUserHandle(model);
//    }
}

#pragma mark - 加载最新/加载更多
- (void)loadDataIsMore:(BOOL)isMore {
    NSInteger offset = self.dataArray.count;
    if (isMore == NO) {
        offset = 0;
    }
    NSInteger limit = 200;
    
    [MZSDKBusinessManager getKickoutUserListWithTicketId:self.ticket_id channelId:self.channel_id offset:offset limit:limit success:^(NSArray* responseObject) {
        NSMutableArray <MZOnlineUserListModel *>*tempArr = responseObject.mutableCopy;
        
        if (offset == 0) {
            self.dataArray = tempArr;
        } else {
            [tempArr enumerateObjectsUsingBlock:^(MZOnlineUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.uid isEqualToString:self.chatIdOfMe]) {
                    [tempArr removeObject:obj];
                    *stop = YES;
                }
            }];
            [self.dataArray addObjectsFromArray:tempArr];
        }
        [self.tableView reloadData];
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
            if (self.dataArray.count < limit) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (responseObject.count < limit) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }

    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSMutableArray<MZOnlineUserListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)updateData {
    [self.tableView.mj_header beginRefreshing];
}

@end
