//
//  MZDiscussCell.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDiscussModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussCell : UITableViewCell

- (void)update:(MZDiscussReplyModel *)reply;

@end

NS_ASSUME_NONNULL_END