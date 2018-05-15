//
//  TubeUserManager.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTubeManager.h"

// 文章类型 普通 专题 连载
typedef NS_ENUM(NSInteger, UserArticleType)
{
    UserArticleTypeMornal = 0x001,
    UserArticleTypeTopic = 0x010,
    UserArticleTypeSerial = 0x100
};

@interface TubeUserManager : BaseTubeManager


- (instancetype)initTubeUserManager:(TubeServerSocketSDK *)tubeServerSocketSDK;

@end
