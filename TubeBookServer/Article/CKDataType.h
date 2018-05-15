//
//  CKDataType.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKDataType : NSObject

typedef NS_ENUM(NSInteger, UserState) {
    UserPublishArticle,
    UserLikeArticle,
};

typedef NS_ENUM(NSInteger, ArticleKind) {
    NormalArticle,
    TopicArticle,
    SerialArticle,
};

typedef NS_ENUM(NSInteger,UIContentCellStyle)
{
    UIContentCellNormalStyle,
    UIContentCellImageRightStyle,
};

@property(nonatomic) UserState userState; //发表或喜欢
@property(nonatomic) BOOL isHaveImage; //是否带有图片
@property(nonatomic) ArticleKind articleKind; // 普通/专题/连载 文章
@property(nonatomic) UIContentCellStyle contentCellStyle;// 内容样式


@end
 
