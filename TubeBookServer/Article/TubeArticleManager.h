//
//  TubeArticleManager.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTubeManager.h"

// 关注或全部
typedef NS_ENUM(NSInteger, FouseType)
{
    FouseTypeAttrent,
    FouseTypeAll,
    FouseTypeCreate
};

// 文章类型 普通 专题 连载
typedef NS_ENUM(NSInteger, ArticleType)
{
    ArticleTypeMornal = 0x001,
    ArticleTypeTopic = 0x010,
    ArticleTypeSerial = 0x100
};

@interface TubeArticleManager : BaseTubeManager

- (instancetype)initTubeArticleManager:(TubeServerSocketSDK *)tubeServerSocketSDK;

@end
