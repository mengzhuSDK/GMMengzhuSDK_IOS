//
//  MZVerticalPlayerViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/6/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVerticalPlayerViewController.h"
#import "MZVerticalPlayerView.h"
#import "UIView+MZPlayPermission.h"
#import "MZRedPackageRecordViewController.h"
#import "MZRedPackageAlert.h"

@interface MZVerticalPlayerViewController ()<MZVerticalPlayerViewProtocol>
@property (nonatomic ,strong) MZVerticalPlayerView *verticalPlayerView;
@property (nonatomic ,strong) UIView *blackContainerView;
@end

@implementation MZVerticalPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - View Helper

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.verticalPlayerView.frame = self.view.bounds;
}

- (void)setupUI  {
    //    初始化带UI的竖屏竖屏播放器View
    self.verticalPlayerView = [[MZVerticalPlayerView alloc] initWithFrame:self.view.bounds];
    //    设置代理接收回调
    self.verticalPlayerView.delegate = self;
    
    if (self.ticket_id.length) {//通过直播ID播放视频
        // 检测是否有权限观看此视频
        [self.view checkPlayPermissionWithTicketId:self.ticket_id phone:[MZBaseUserServer currentUser].phone success:^(BOOL isPermission) {
            if (isPermission) {
                [self.view addSubview:self.verticalPlayerView];
                [self.verticalPlayerView playVideoWithLiveIDString:self.ticket_id];
            }
        } cancelButtonClick:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else if (self.mvURLString.length) {
        [self.view addSubview:self.verticalPlayerView];
        [self.verticalPlayerView playVideoWithLocalMVURLString:self.mvURLString];
    }
}

//toast提示 测试使用
-(void)sv_showMessage:(NSString*)message;{
    if (self.blackContainerView) {
        [self sv_dismissProgressView];
    }
    NSArray *wins=[UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [wins objectAtIndex:0];
    UIView *blackContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 152*MZ_RATE, 44*MZ_RATE)];
    blackContainerView.backgroundColor = MakeColorRGBA(0x000000, 0.8);
    [blackContainerView roundChangeWithRadius:10*MZ_RATE];
    [keyWindow addSubview:blackContainerView];
    blackContainerView.center = keyWindow.center;
    self.blackContainerView = blackContainerView;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [blackContainerView addSubview:infoLabel];
    infoLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.text = message;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.frame = blackContainerView.bounds;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sv_dismissProgressView];
    });
}
-(void)sv_dismissProgressView;{
    if (self.blackContainerView) {
        [self.blackContainerView removeFromSuperview];
        self.blackContainerView = nil;
    }
}


#pragma mark - 播放器代理
- (void)closeButtonDidClick:(id)playInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)avatarDidClick:(MZHostModel *)hostModel {
     NSLog(@"%s",__func__);
    [self sv_showMessage:@"主播头像点击"];
}

- (void)updateHostUserInfo:(MZHostModel *)hostModel {
    NSLog(@"获取到了主播信息 = %@ - %@ - %@",hostModel.nickname,hostModel.uid,hostModel.unique_id);
}

- (void)reportButtonDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"举报点击"];
}
- (void)barrageShow:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"显示弹幕"];
}

- (void)barrageHide:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"隐藏弹幕"];
}

- (void)shareButtonDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"分享点击"];
}

- (void)likeButtonDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
}

- (void)onlineListButtonDidClick:(id)playInfo {
    [self sv_showMessage:@"在线用户列表点击"];
}

- (void)onlineUserInfoDidClick:(id)onlineUserInfo {
//    [self sv_showMessage:@"点击一个在线用户"];
}

- (void)shoppingBagDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"购物点击"];
}

- (void)attentionButtonDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"关注点击"];
}

- (void)chatUserDidClick:(id)playInfo {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"聊天用户点击"];
}

- (void)goodsItemDidClick:(MZGoodsListModel *)GoodsListModel {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"商品点击"];
}

- (void)chatUserHeaderDidClick:(MZLongPollDataModel *)GoodsListModel {
    NSLog(@"%s",__func__);
//    [self sv_showMessage:@"聊天点击"];
}

- (void)redPackageClick:(MZLongPollDataModel *)redPackageModel {
    NSLog(@"点击一条红包消息：%@ - %@ - %@ - %@ - %@ - %@",redPackageModel.data.slogan, redPackageModel.data.amount, redPackageModel.data.nickname, redPackageModel.data.unique_id, redPackageModel.data.bonus_id, redPackageModel.data.buyerAvatar);
    
    __weak typeof(self) weakSelf = self;
    [MZRedPackageAlert showWithBonus_id:redPackageModel.data.bonus_id slogan:redPackageModel.data.slogan nickname:redPackageModel.data.nickname avatar:redPackageModel.data.buyerAvatar isGoReceiveList:^(BOOL isGoReceiveList) {
        if (isGoReceiveList) {
            MZRedPackageRecordViewController *redPackageRecordVC = [[MZRedPackageRecordViewController alloc] initWithBonus_id:redPackageModel.data.bonus_id];
            redPackageRecordVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:redPackageRecordVC animated:YES completion:nil];
        }
    }];
}

- (void)playerNotLogin {
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"未登录"];
}

- (void)newMsgCallback:(MZLongPollDataModel *)msg {
     if (msg.event == MsgTypeOnline) {//上线消息
            
     } else if(msg.event == MsgTypeOffline) {//下线消息
    //
     } else if(msg.event == MsgTypeOtherChat || msg.event == MsgTypeMeChat) {//文本消息
            
     } else if (msg.event == MsgTypeGoodsUrl) {//推广商品
           
     } else if (msg.event == MsgTypeLiveOver) {//主播暂时离开
           
     } else if (msg.event == MsgTypeLiveReallyEnd) {//直播结束
           
     } else if (msg.event == MsgTypeDisableChat) {//用户禁言
            
     } else if (msg.event == MsgTypeAbleChat) {//取消禁言
            
     }
}

/// 收到某个用户被踢出的消息
- (void)newMsgForKickoutOneUser:(MZLongPollDataModel *)msg {

}

/**
 * @brief 点击了投屏帮助按钮
 */
- (void)DLNAHelpClick {
    [self sv_showMessage:@"点击了投屏帮助按钮"];
}

/**
 * @brief 播放按钮点击
 */
- (void)playerPlayClick:(BOOL)isPlay {
}

/**
 * @brief 快进退 进度回调
 */
- (void)playerSeekProgress:(NSTimeInterval)progress {
}

/**
 * @brief 快进退 手势回调
 */
- (void)playerSeekLocation:(float)location {

}

/**
 * @brief 声音大小手势回调
 */
- (void)playerVoiceSize:(float)size {
}

/**
 * @brief 亮度手势回调
 */
- (void)playerLuminance:(float)luminance {
}

/**
 * @brief 是否显示下方工具栏
 */
- (void)isPlayToolsShow:(BOOL)isShow {

}

/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type {
//    NSLog(@"开始播放状态回调");
}

/**
 播放中状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type {
    NSLog(@"播放中的状态更改回调");
}

/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type {
    NSLog(@"播放结束");
}

/**
 准备播放完成
 */
- (void)mediaIsPreparedToPlayDidChange {
    NSLog(@"播放准备完成");
}

/**
 * 播放失败
 */
- (void)playerViewFailePlay:(MZMediaPlayerView *)player {

}




//-(void)loginUpdate{
//    MZUser *user=[MZBaseUserServer currentUser];
//    user.avatar=@"https://upload.jianshu.io/users/upload_avatars/2640663/d6f196c2717c?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp";
//        user.nickName=@"22222";
//        [MZBaseUserServer updateCurrentUser:user];
//}


@end
