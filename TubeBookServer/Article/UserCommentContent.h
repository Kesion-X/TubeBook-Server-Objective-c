//
//  UserCommentContent.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/30.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKContent.h"

typedef NS_ENUM(NSInteger, CommentFromType)
{
    CommentFromTypeArticle,
    CommentFromTypeArticleUser,
};

@interface UserCommentContent : CKContent

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString *toUid;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) BOOL isReview;
@property (nonatomic, assign) CommentFromType commentFromType;

@end
