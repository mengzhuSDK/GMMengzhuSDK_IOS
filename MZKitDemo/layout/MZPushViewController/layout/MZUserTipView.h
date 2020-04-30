//
//  MZUserTipView.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/25.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZUserTipTypeCancel = 1,
    MZUserTipTypeBanned,
    MZUserTipTypeUnBanned,
    MZUserTipTypeOther,
} MZUserTipType;

typedef void(^UserTipBlock)(MZUserTipType type);

@interface MZUserTipView : MZBaseView

@property (nonatomic ,strong)MZLiveUserModel *otherUser;

@property (nonatomic,copy) UserTipBlock userTipBlock;
@end

NS_ASSUME_NONNULL_END