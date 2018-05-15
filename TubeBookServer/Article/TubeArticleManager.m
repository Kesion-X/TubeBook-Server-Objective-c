//
//  TubeArticleManager.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeArticleManager.h"
#import "TimeUtil.h"
#import "UserSimilarity.h"
#import "UserCommentContent.h"

@interface TubeArticleManager ()



@end

@implementation TubeArticleManager

- (instancetype)initTubeArticleManager:(TubeServerSocketSDK *)tubeServerSocketSDK
{
    self = [super initBaseTubeManager:tubeServerSocketSDK];
    if (self) {

    }
    return self;
}

- (void)acceptNewClient:(GCDAsyncSocket *)sock
{
    
}

- (void)didReadData:(GCDAsyncSocket *)sock didReadData:(NSData *)data protocolName:(NSString *)protocolName
{
    if ([protocolName isEqualToString:ARTICLE_PROTOCOL]) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *headDir = [dic objectForKey:@"head"];
        NSString *method = [headDir objectForKey:PROTOCOL_METHOD];
        if ( [method isEqualToString:ARTICLE_PROTOCOL_TAG]) {
            [self responseTagList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_PROTOCOL_ADD_TAG]) {
            [self responseAddTag:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_TOPIC_TITLE_LIST]) {
            [self responseTopicList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_UPLOAD]) {
            [self responseUpLoadArticle:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SET_TAGS]) {
            [self respsonseSetTags:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SET_TAB]) {
            [self respsonseSetTab:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SERIAL_TITLE_LIST]) {
            [self respsonseSerialList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_NEW_LIST]) {
            [self responseNewArticleList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_TOPIC_DETAIL_INFO]) {
            [self responseArticleTopicDetialInfo:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SERIAL_DETAIL_INFO]) {
            [self responseArticleSerialDetailInfo:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_ID_DETAIL_INFO]) {
            [self responseArticleDetailInfoByid:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SET_LIKE]) {
            [self responseSetArticleLikeStatus:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_LIKE_NOT_REVIEW_COUNT]) {
            [self responseArticleNotLikeReviewCount:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_CREATE_TOPIC_OR_SERIAL_TAB]) {
            [self responseCreateTopicOrSerialTab:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_RECOMMEND_BY_HOT_LIST]) {
            [self responsAritcleRecommedByHotList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_RECOMMEND_BY_USERCF_LIST]) {
            [self responsAritcleRecommedByUserCFList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_LIKE_STATUS]) {
            [self responsAritcleLikeStatus:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_TAB_LIKE_STATUS]) {
            [self responsAritcleTabLikeStatus:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_TAB_SET_LIKE]) {
            [self responseSetArticleTabLikeStatus:dic socket:sock];
        } else if ([method isEqualToString:ARITCLE_USER_LIKE_LIST]) {
            [self responseUserLikeArticleList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_COMMENT_TO_USER]) {
            [self responseArticleCommentToUser:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_COMMENT_LIST]) {
            [self responseArticleCommentList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_USER_COMMENT_TO_USER]) {
            [self requestArticleUserCommentToUser:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_USER_COMMENT_TO_USER_LIST]) {
            [self requestArticleUserCommentToUserList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_COMMENT_NOT_REVIEW_COUNT]) {
            [self requestArticleCommentNotReviewCount:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_RECEIVE_COMMENT_LIST]) {
            [self requestArticleReceiveCommentList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_COMMENT_FROM_USER_TO_USER_LIST]) {
            [self requestArticleCommentFromUserToUserList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_COMMENT_BY_CID]) {
            [self requestArticleCommentByCid:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_SET_COMMENT_REVIEW_STATUS]) {
            [self requestArticleCommentTypeStatus:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_RECEIVE_USER_LIKE_ARTICLE_LIST]) {
            [self requestArticleReceiveUserLikeArticleList:dic socket:sock];
        } else if ([method isEqualToString:ARTICLE_USER_CREATE_ARTICLE_COUNT]) {
            [self requestArticleUserCreateArticleCount:dic socket:sock];
        }
        

    }
}

- (void)requestArticleUserCreateArticleCount:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSInteger count = 0;
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from article_table where userid = '%@'",uid] tableName:nil];
        if (list) {
            NSDictionary *dic = [list objectAtIndex:0];
            count = [[dic objectForKey:@"count(*)"] integerValue];
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                @(count), @"count",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_USER_CREATE_ARTICLE_COUNT,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleReceiveUserLikeArticleList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSMutableArray *mList = [[NSMutableArray alloc] init];
    BOOL isOK = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOK = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select at_user_like_table.*,title from at_user_like_table left "
                                                                     " join article_table on at_user_like_table.atid = article_table.atid "
                                                                     " where article_table.userid = '%@' and at_user_like_table.ishaved_review = 0 "
                                                                     " and at_user_like_table.userid != '%@' order by (at_user_like_table.time) desc limit %lu,10;", uid, uid, index*10] tableName:nil];
        if (list) {
            [mList addObjectsFromArray:list];
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mList, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_RECEIVE_USER_LIKE_ARTICLE_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleCommentTypeStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger tid = [[contentDir objectForKey:@"tid"] integerValue];
    CommentFromType commentfromType = [[contentDir objectForKey:@"commentType"] integerValue];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        if (commentfromType == CommentFromTypeArticle) {
            if ([[DBHelper sharedInstance] updateWithTable:@"atcomment_table" keyAndVaule:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                                           @(YES),@"ishaved_review",nil] where:[NSString stringWithFormat:@" id = %lu ",tid]] !=0) {
                isOk = NO;
            }
        } else {
            if ([[DBHelper sharedInstance] updateWithTable:@"at_user_comment_table" keyAndVaule:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                                           @(YES),@"ishaved_review",nil] where:[NSString stringWithFormat:@" id = %lu ",tid]] !=0) {
                isOk = NO;
            }
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_SET_COMMENT_REVIEW_STATUS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleCommentByCid:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger cid = [[contentDir objectForKey:@"cid"] integerValue];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSDictionary *commentContent  = nil;
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from atcomment_table left join article_table on atcomment_table.atid = article_table.atid where atcomment_table.id = %lu",cid] tableName:nil];
        if (list) {
            NSDictionary *dic = [list objectAtIndex:0];
            commentContent = dic;
        }

    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                commentContent, @"commentContent",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_COMMENT_BY_CID,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleCommentFromUserToUserList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger cid = [[contentDir objectForKey:@"cid"] integerValue];
    NSString *fromUid = [contentDir objectForKey:@"fromUid"];
    NSString *toUid = [contentDir objectForKey:@"toUid"];
    NSInteger tid = [[contentDir objectForKey:@"tid"] integerValue];
    NSInteger commentId = [[contentDir objectForKey:@"commentId"] integerValue];
    CommentFromType commentType = [[contentDir objectForKey:@"commentType"] integerValue];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    if (isOK && commentType == CommentFromTypeArticle) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and ((receive_userid='%@' && send_userid='%@') or (receive_userid='%@' && send_userid='%@')) order by (comment_time) desc", cid, fromUid, toUid, toUid, fromUid] tableName:nil];
        if (list) {
            [mlist addObjectsFromArray:list];
        }
    }
//    if (isOK) {
//
//        if (commentId == -1) {
//            if (commentType == CommentFromTypeArticle) {
//                NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and ((receive_userid='%@' && send_userid='%@') or (receive_userid='%@' && send_userid='%@')) order by (comment_time) desc", cid, fromUid, toUid, toUid, fromUid] tableName:nil];
//                if (list) {
//                    [mlist addObjectsFromArray:list];
//                }
//
//            } else {
//                NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and id=%lu order by (comment_time) asc", cid, tid] tableName:nil];
//                if (list) {
//                    NSDictionary *dic = [list objectAtIndex:0];
//                    [mlist insertObject:dic atIndex:0];
//                }
//
//                NSInteger mmCommentId = tid;
//                NSMutableArray *clist = [[NSMutableArray alloc] init];
//                [clist addObject:@(mmCommentId)];
//                while (clist.count>0) {
//                    mmCommentId = [[clist objectAtIndex:0] integerValue];
//                    NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and ((receive_userid='%@' && send_userid='%@') or (receive_userid='%@' && send_userid='%@')) and comment_id=%lu order by (comment_time) asc", cid, fromUid, toUid, toUid, fromUid, mmCommentId] tableName:nil];
//                    if (list) {
//                        [mlist addObjectsFromArray:list];
//                        for (NSDictionary *dic in list) {
//                            mmCommentId = [[dic objectForKey:@"id"] integerValue];
//                            [clist addObject:@(mmCommentId)];
//                        }
//                    }
//                    [clist removeObjectAtIndex:0];
//                }
//            }
//
//        } else {
//            NSInteger mCommentId = commentId;
//            while (mCommentId!=-1) {
//                NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and id=%lu order by (comment_time) asc", cid, mCommentId] tableName:nil];
//                if (list) {
//                    NSDictionary *dic = [list objectAtIndex:0];
//                    mCommentId = [[dic objectForKey:@"comment_id"] integerValue];
//                    [mlist insertObject:dic atIndex:0];
//                } else {
//                    break;
//                }
//            }
//            NSInteger mmCommentId = commentId;
//            NSMutableArray *clist = [[NSMutableArray alloc] init];
//            [clist addObject:@(mmCommentId)];
//            while (clist.count>0) {
//                mmCommentId = [[clist objectAtIndex:0] integerValue];
//                NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu and ((receive_userid='%@' && send_userid='%@') or (receive_userid='%@' && send_userid='%@')) and comment_id=%lu order by (comment_time) asc", cid, fromUid, toUid, toUid, fromUid, mmCommentId] tableName:nil];
//                if (list) {
//                    [mlist addObjectsFromArray:list];
//                    for (NSDictionary *dic in list) {
//                        mmCommentId = [[dic objectForKey:@"id"] integerValue];
//                        [clist addObject:@(mmCommentId)];
//                    }
//                }
//                [clist removeObjectAtIndex:0];
//            }
//        }
//
//    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mlist, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_COMMENT_FROM_USER_TO_USER_LIST, PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleReceiveCommentList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    NSMutableArray *requestList = [[NSMutableArray alloc] init];
    if (isOk) {
        NSArray *commentlist = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from atcomment_table where receive_userid = '%@' order by (comment_time) desc limit %lu,5;",uid, index*5] tableName:nil];
        if (commentlist) {
            [mlist addObjectsFromArray:commentlist];
        }
        NSArray *userCommentList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where receive_userid = '%@' order by (comment_time) desc limit %lu,5;",uid, index*5] tableName:nil];
        if (userCommentList) {
            [mlist addObjectsFromArray:userCommentList];
        }
    }
    for (NSDictionary *dic in mlist){
        UserCommentContent *content = [[UserCommentContent alloc] init];
        content.id = [[dic objectForKey:@"id"] integerValue];
        content.userUid = [dic objectForKey:@"send_userid"];
        content.toUid = [dic objectForKey:@"receive_userid"];
        content.comment = [dic objectForKey:@"comment"];
        content.atid = [dic objectForKey:@"atid"];
        content.t_time = [[dic objectForKey:@"comment_time"] integerValue];
        content.time = [TimeUtil getDateWithTime:content.t_time];
        content.isReview = [[dic objectForKey:@"ishaved_review"] boolValue];
        if ([dic objectForKey:@"cid"]) {
            content.cid = [[dic objectForKey:@"cid"] integerValue];
            content.commentId = [[dic objectForKey:@"comment_id"] integerValue];
            content.commentFromType = CommentFromTypeArticleUser;
        } else {
            content.cid = [[dic objectForKey:@"id"] integerValue];
            content.commentId = -1;
            content.commentFromType = CommentFromTypeArticle;
        }
        if (content.atid && content.atid.length > 0) {
            NSArray *aList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select title from article_table where atid = '%@'",content.atid] tableName:nil];
            if (aList) {
                NSDictionary *adic = [aList objectAtIndex:0];
                content.articleTitle = [adic objectForKey:@"title"];
            }
        }
        [requestList addObject:content];
    }
    NSArray *sortedArray = [requestList sortedArrayUsingComparator:^NSComparisonResult(UserCommentContent *p1, UserCommentContent *p2){
        if (p1.t_time < p2.t_time) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    int i=0;
    for (UserCommentContent *content in sortedArray) {
        NSDictionary *dic = @{@"id":@(content.id),
                              @"cid":@(content.cid),
                              @"comment_id":@(content.commentId),
                              @"atid":content.atid,
                              @"send_userid":content.userUid,
                              @"receive_userid":content.toUid,
                              @"comment_time":content.time,
                              @"t_comment_time":@(content.t_time),
                              @"ishaved_review":@(content.isReview),
                              @"comment_from_type":@(content.commentFromType),
                              @"article_title":content.articleTitle,
                              @"comment":content.comment
                              };
        NSLog(@"error  %d",i);
        i++;
        [resultList addObject:dic];
    }
    
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                resultList, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_RECEIVE_COMMENT_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (void)requestArticleCommentNotReviewCount:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSInteger count = 0;
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from atcomment_table where receive_userid = '%@' and ishaved_review=0;",uid] tableName:nil];
        if (list) {
            NSDictionary *dic = [list objectAtIndex:0];
            count = [[dic objectForKey:@"count(*)"] integerValue];
        }
        NSArray *userCList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from at_user_comment_table where receive_userid = '%@' and ishaved_review=0;", uid] tableName:nil];
        if (userCList) {
            NSDictionary *dic = [userCList objectAtIndex:0];
            count += [[dic objectForKey:@"count(*)"] integerValue];
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                @(count), @"count",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_COMMENT_NOT_REVIEW_COUNT,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleUserCommentToUserList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger cid = [[contentDir objectForKey:@"cid"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    if (isOK) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_comment_table where cid = %lu order by (comment_time) desc limit %lu,10;", cid, index*10] tableName:nil];
        if (list) {
            [mlist addObjectsFromArray:list];
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mlist, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_USER_COMMENT_TO_USER_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestArticleUserCommentToUser:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSString *fromUid = [contentDir objectForKey:@"fromUid"];
    NSString *toUid = [contentDir objectForKey:@"toUid"];
    NSString *message = [contentDir objectForKey:@"message"];
    NSInteger cid = [[contentDir objectForKey:@"cid"] integerValue];
    NSInteger commentId =  [[contentDir objectForKey:@"commentId"] integerValue];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    if (isOK) {
        if ([[DBHelper sharedInstance] insterWithTable:@"at_user_comment_table" keys:@[@"cid",@"atid", @"receive_userid", @"send_userid", @"comment", @"comment_time", @"ishaved_review", @"comment_id"] values:@[@(cid), atid, toUid, fromUid, message, @([TimeUtil getNowTimeTimest]), @(NO), @(commentId)]] == 0) {
            isOK = YES;
            
            [self sendNotificationMessageWithreceiveUid:toUid
                                             sendSocket:sock
                                               protocol:IM_PROTOCOL
                                                 method:IM_NOTIFICATION_MESSAGE
                                                  title:[NSString stringWithFormat:@"%@回复了你",fromUid]
                                                content:[NSString stringWithFormat:@"回复了你: %@", message]];
        } else {
            isOK = NO;
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_USER_COMMENT_TO_USER,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseArticleCommentList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    if (isOK) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select atcomment_table.id,atcomment_table.atid,atcomment_table.receive_userid,atcomment_table.send_userid,atcomment_table.comment,atcomment_table.comment_time,count(cid) from atcomment_table "
                                                                     " left join at_user_comment_table  on at_user_comment_table.cid=atcomment_table.id "
                                                                     " where atcomment_table.atid='%@' "
                                                                     " group by  id,atid,receive_userid,send_userid,comment,comment_time,cid "
                                                                     " order by (comment_time) desc limit %lu,10; ", atid,index*10] tableName:nil];
        if (list) {
            [mlist addObjectsFromArray:list];
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mlist, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_COMMENT_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseArticleCommentToUser:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSString *fromUid = [contentDir objectForKey:@"fromUid"];
    NSString *toUid = [contentDir objectForKey:@"toUid"];
    NSString *message = [contentDir objectForKey:@"message"];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    if (isOK) {
        if ([[DBHelper sharedInstance] insterWithTable:@"atcomment_table" keys:@[@"atid", @"receive_userid", @"send_userid", @"comment", @"comment_time", @"ishaved_review"] values:@[atid, toUid, fromUid, message, @([TimeUtil getNowTimeTimest]), @(NO)]] == 0) {
            isOK = YES;
 
            NSArray *aList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from article_table where atid='%@'", atid] tableName:@"article_table"];
            NSDictionary *aDic = [aList objectAtIndex:0];
            NSString *uid = [aDic objectForKey:@"userid"];
            NSString *articleTitle = [aDic objectForKey:@"title"];
            [self sendNotificationMessageWithreceiveUid:uid
                                             sendSocket:sock
                                               protocol:IM_PROTOCOL
                                                 method:IM_NOTIFICATION_MESSAGE
                                                  title:[NSString stringWithFormat:@"%@评论了你的文章",fromUid]
                                                content:[NSString stringWithFormat:@"评论你的文章《%@》: %@", articleTitle, message]];
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_COMMENT_TO_USER,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseUserLikeArticleList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSMutableArray *mList = [[NSMutableArray alloc] init];
    BOOL isOK = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOK = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.* from at_user_like_table "
                                                                     " left join article_table on at_user_like_table.atid=article_table.atid "
                                                                     " where at_user_like_table.userid = '%@' limit %lu,10;", uid, index*10] tableName:nil];
        if (list) {
            [mList addObjectsFromArray:list];
        }
    }
    NSString *status = @"fail";
    if (isOK) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mList, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARITCLE_USER_LIKE_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (void)responseSetArticleTabLikeStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL likeStatus = [[contentDir objectForKey:@"likeStatus"] boolValue];
    ArticleType articleType = [[contentDir objectForKey:@"articleType"] integerValue];
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from user_attent_tab_table where tabid=%lu and userid='%@' ", tabid,uid] tableName:@"user_attent_tab_table"];
        if (list) {
            if (!likeStatus) {
                [[DBHelper sharedInstance] delectWithTable:@"user_attent_tab_table" where:[NSString stringWithFormat:@" tabid=%lu and userid='%@' ", tabid,uid]];
            }
        } else {
            if (likeStatus) {
                [[DBHelper sharedInstance] insterWithTable:@"user_attent_tab_table" keys:@[@"tabid",@"userid",@"type"] values:@[@(tabid),uid,@(articleType)]];
            }
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_TAB_SET_LIKE,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responsAritcleTabLikeStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    BOOL isLike = NO;
    if ( isOK ) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select * from user_attent_tab_table where tabid = %lu and userid = '%@';", tabid, uid] tableName:nil];
        if (list) {
            isLike = YES;
        }
    }
    NSString *status = @"fail";
    if ( isOK ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                @(isLike), @"isLike",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_TAB_LIKE_STATUS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responsAritcleLikeStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSString *atid = [contentDir objectForKey:@"atid"];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    BOOL isLike = NO;
    if ( isOK ) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select * from at_user_like_table where atid = '%@' and userid = '%@';", atid, uid] tableName:nil];
        if (list) {
            isLike = YES;
        }
    }
    NSString *status = @"fail";
    if ( isOK ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                @(isLike), @"isLike",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_LIKE_STATUS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responsAritcleRecommedByUserCFList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    ArticleType articleType = [[contentDir objectForKey:@"articleType"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    BOOL isOK = [[DBHelper sharedInstance] connectionDB];
    if ( isOK && (index == 0) ) {
        // 获取本用户的浏览历史
        NSArray *userReviewList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select atid,review_count from at_user_review_table where userid = '%@';",uid] tableName:nil];
        NSMutableDictionary *userAtidForReviewDic = [[NSMutableDictionary alloc] init];
        NSInteger userReviewTotal = 0;
        CGFloat userAvgReview = 0;
        for (NSDictionary *dic in userReviewList) {
            NSString *key = [dic objectForKey:@"atid"];
            NSInteger value = [[dic objectForKey:@"review_count"] integerValue];
            userReviewTotal += value;
            [userAtidForReviewDic setObject:@(value * 1.0f) forKey:key];
        }
        userAvgReview = userReviewTotal*1.0f / userReviewList.count; // 浏览平均值
        
        // 获取所有用户
        NSArray *otherUserList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select account from ap_table where account != '%@';",uid] tableName:nil];
        
        NSMutableArray *otherUserSimirityList = [[NSMutableArray alloc] init];
        for (NSDictionary *otherUser in otherUserList) {
            
            // 得出其他用户浏览历史
            NSString *otherUid = [otherUser objectForKey:@"account"];
            NSArray *otherUserReviewList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select atid,review_count from at_user_review_table where userid = '%@';",otherUid] tableName:nil];
            if (!otherUserReviewList) {
                continue ;
            }
            NSMutableDictionary *otherUserAtidForReviewDic = [[NSMutableDictionary alloc] init];
            NSInteger otherUserReviewTotal = 0;
            CGFloat otherUserAvgReview = 0;
            for (NSDictionary *dic in otherUserReviewList) {
                NSString *key = [dic objectForKey:@"atid"];
                NSInteger value = [[dic objectForKey:@"review_count"] integerValue];
                otherUserReviewTotal += value;
                [otherUserAtidForReviewDic setObject:@(value * 1.0f) forKey:key];
            }
            otherUserAvgReview = otherUserReviewTotal*1.0f / otherUserReviewList.count;
            
            // 以平均值填充其他用户nil值
            for ( NSString *otherUserAtid in otherUserAtidForReviewDic.allKeys ) {
                if ( ![userAtidForReviewDic objectForKey:otherUserAtid] ) {
                    [userAtidForReviewDic setObject:@(userAvgReview) forKey:otherUserAtid];
                }
            }
            // 以平均值填充本用户nil值
            for (NSString *userAtid in userAtidForReviewDic) {
                if ( ![otherUserAtidForReviewDic objectForKey:userAtid] ) {
                    [otherUserAtidForReviewDic setObject:@(otherUserAvgReview) forKey:userAtid];
                }
            }
            
            CGFloat element = 0.0f;
            CGFloat denominator;
            CGFloat otherDenominatorX = 0.0f;
            CGFloat selfDenominatorY = 0.0f;
            // 计算分子
            for (NSString *key in userAtidForReviewDic) {
                CGFloat x = [[otherUserAtidForReviewDic objectForKey:key] floatValue];
                CGFloat otherUserX = x - otherUserAvgReview;
                CGFloat userY = [[userAtidForReviewDic objectForKey:key] floatValue] - userAvgReview;
                element += (otherUserX * userY);
                otherDenominatorX += otherUserX * otherUserX;
                selfDenominatorY += userY * userY;
            }
            // 计算分母
            denominator = sqrt(otherDenominatorX) * sqrt(selfDenominatorY);
            
            if ( denominator==0 ) {
                UserSimilarity *userSimilarityItem = [[UserSimilarity alloc] initUserSimilarityWithUid:otherUid similarityPrice:0];
                [otherUserSimirityList addObject:userSimilarityItem];
                continue;
            }
            // 计算相似值
            CGFloat similarityPrime = element / denominator;
            if ( similarityPrime<0 && similarityPrime>=-1 ) {
                similarityPrime = 1+similarityPrime;
            }
            UserSimilarity *userSimilarityItem = [[UserSimilarity alloc] initUserSimilarityWithUid:otherUid similarityPrice:similarityPrime];
            [otherUserSimirityList addObject:userSimilarityItem];
        }
        
        NSArray *sortedArray = [otherUserSimirityList sortedArrayUsingComparator:^NSComparisonResult(UserSimilarity *p1, UserSimilarity *p2){
            if (p1.similarityPrice < p2.similarityPrice) {
                return NSOrderedDescending;
            }
             return NSOrderedAscending;
        }];

        NSLog(@" similarity sort list %@",sortedArray);
        
        // 将相识度存入表中
        [[DBHelper sharedInstance] delectWithTable:@"user_simirity_table" where:[NSString stringWithFormat:@" uid='%@' ",uid]];
        for ( UserSimilarity *userSimilarityItem in sortedArray ) {
            [[DBHelper sharedInstance] insterWithTable:@"user_simirity_table" keys:@[@"uid",@"otheruid",@"simirity_prime"] values:@[uid,userSimilarityItem.uid,@(userSimilarityItem.similarityPrice * 1.0f)]];
        }
        
    // ----------- 以上已获取相似用户，并以用户相似度进行排序 ---------------------
    
    }
    
    NSString *status = @"fail";
    // ------------------ 开始获取相似用户，且自己未曾看过的文章 --------------------
    if (isOK) {
        status = @"success";
        NSString *articleTypeSql = @"";
        // 选取文章类型
        if ( articleType & ArticleTypeMornal ) {
            articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeMornal]];
        }
        if ( articleType & ArticleTypeSerial ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeSerial]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeSerial]];
            }
        }
        if ( articleType & ArticleTypeTopic ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeTopic]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeTopic]];
            }
        }
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select at_user_review_table.atid,title,tabtype,tabid,article_table.userid,simirity_prime,createtime,description,articlepic,review_count from at_user_review_table "
                                                                     " left join article_table on at_user_review_table.atid = article_table.atid "
                                                                     " left join atab_table on at_user_review_table.atid = atab_table.atid "
                                                                     " left join user_simirity_table on at_user_review_table.userid = user_simirity_table.otheruid "
                                                                     " where at_user_review_table.userid in (select otheruid from user_simirity_table where uid='%@') "
                                                                     " and (%@) order by review_count"
                                                                     " limit %lu,10;", uid, articleTypeSql, index*10] tableName:nil];
         //    " and at_user_review_table.atid not in (select atid from at_user_review_table where userid='%@') "
        //group by atid,title,tabtype,tabid,userid,simirity_prime,createtime,description,articlepic
        if (list) {
            [mlist addObjectsFromArray:list];
        }
        
    }
    if (mlist.count == 0 ) {
        NSArray *list = [self getHotListByUid:uid articleType:ArticleTypeMornal|ArticleTypeTopic|ArticleTypeSerial index:index fouseType:FouseTypeAll];
        if (list) {
            [mlist addObjectsFromArray:list];
        }
    }
    NSMutableArray *reList = [[NSMutableArray alloc] init];
    for (NSDictionary *d in mlist) {
        NSString *dAtid = [d objectForKey:@"atid"];
        BOOL h = NO;
        for (NSDictionary *reD in reList) {
            NSString *reAtid = [reD objectForKey:@"atid"];
            if ([dAtid isEqualToString:reAtid]) {
                h = YES;
                break;
            }
        }
        if (!h) {
            [reList addObject:d];
        }
    }
    
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                reList, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_RECOMMEND_BY_USERCF_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responsAritcleRecommedByHotList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    ArticleType articleType = [[contentDir objectForKey:@"articleType"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    FouseType fouseType = [[contentDir objectForKey:@"fouseType"] integerValue];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        NSString *articleTypeSql = @"";
        // 选取文章类型
        if ( articleType & ArticleTypeMornal ) {
            articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeMornal]];
        }
        if ( articleType & ArticleTypeSerial ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeSerial]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeSerial]];
            }
        }
        if ( articleType & ArticleTypeTopic ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeTopic]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeTopic]];
            }
        }
        
        if ( fouseType == FouseTypeAttrent ) {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select article_table.atid,article_table.userid,title,description,createtime,articlepic,body,tabtype,tabid,sum(review_count) "
                                                        " from article_table right join at_user_review_table on article_table.atid = at_user_review_table.atid "
                                                        " right join atab_table on article_table.atid = atab_table.atid "
                                                         " where article_table.userid in (select attentioned_userid from user_attention_table where attention_userid = '%@') "
                                                         " and (%@) "
                                                        " group by atid,userid,title,description,createtime,articlepic,body,tabtype,tabid "
                                                        " order by sum(review_count) desc limit %lu,10;", uid, articleTypeSql, index * 10] tableName:nil];
            if (list) {
                [mlist addObjectsFromArray:list];
            }
        } else if ( fouseType == FouseTypeAll ) {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select article_table.atid,article_table.userid,title,description,createtime,articlepic,body,tabtype,tabid,sum(review_count) "
                                                                        " from article_table right join at_user_review_table on article_table.atid = at_user_review_table.atid "
                                                                        " right join atab_table on article_table.atid = atab_table.atid "
                                                                        " where article_table.userid in (select attentioned_userid from user_attention_table) "
                                                                        " and (%@) "
                                                                        " group by atid,userid,title,description,createtime,articlepic,body,tabtype,tabid "
                                                                        " order by sum(review_count) desc limit %lu,10; ", articleTypeSql, index*10]  tableName:nil];
            if (list) {
                [mlist addObjectsFromArray:list];
            }
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mlist, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_RECOMMEND_BY_HOT_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (NSMutableArray *)getHotListByUid:(NSString *)uid articleType:(ArticleType)articleType index:(NSInteger)index fouseType:(FouseType)fouseType
{
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        NSString *articleTypeSql = @"";
        // 选取文章类型
        if ( articleType & ArticleTypeMornal ) {
            articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeMornal]];
        }
        if ( articleType & ArticleTypeSerial ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeSerial]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeSerial]];
            }
        }
        if ( articleType & ArticleTypeTopic ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeTopic]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeTopic]];
            }
        }
        
        if ( fouseType == FouseTypeAttrent ) {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select article_table.atid,article_table.userid,title,description,createtime,articlepic,body,tabtype,tabid,sum(review_count) "
                                                                         " from article_table right join at_user_review_table on article_table.atid = at_user_review_table.atid "
                                                                         " right join atab_table on article_table.atid = atab_table.atid "
                                                                         " where article_table.userid in (select attentioned_userid from user_attention_table where attention_userid = '%@') "
                                                                         " and (%@) "
                                                                         " group by atid,userid,title,description,createtime,articlepic,body,tabtype,tabid "
                                                                         " order by sum(review_count) desc limit %lu,10;", uid, articleTypeSql, index * 10] tableName:nil];
            if (list) {
                [mlist addObjectsFromArray:list];
            }
        } else if ( fouseType == FouseTypeAll ) {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@" select article_table.atid,article_table.userid,title,description,createtime,articlepic,body,tabtype,tabid,sum(review_count) from article_table "
                                                                         " left join at_user_review_table on article_table.atid = at_user_review_table.atid "
                                                                         " right join atab_table on article_table.atid = atab_table.atid "
                                                                         " where (%@) "
                                                                         " group by atid,userid,title,description,createtime,articlepic,body,tabtype,tabid "
                                                                         " order by sum(review_count) desc limit %lu,10; ", articleTypeSql, index*10]  tableName:nil];
            if (list) {
                [mlist addObjectsFromArray:list];
            }
        }
    }
    return mlist;
}

- (void)responseCreateTopicOrSerialTab:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    ArticleType type = [[contentDir objectForKey:@"type"] integerValue];
    NSString *title = [contentDir objectForKey:@"title"];
    NSString *description = [contentDir objectForKey:@"description"];
    NSString *pic = [contentDir objectForKey:@"pic"];
    BOOL isOK = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        if ( [[DBHelper sharedInstance] insterWithTable:@"tab_table" keys:@[@"create_userid", @"type", @"title", @"description", @"create_time", @"pic"] values:@[uid, @(type), title, description, [TimeUtil getNowTimeTimestamp3], pic]] == 0 ) {
            isOK = YES;
        }
    }
    NSString *status = @"fail";
    if ( isOK ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_CREATE_TOPIC_OR_SERIAL_TAB,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (void)responseArticleNotLikeReviewCount:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isOk = NO;
    NSInteger count = 0;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from at_user_like_table "
                                                                     " left join article_table on at_user_like_table.atid = article_table.atid "
                                                                     " where article_table.userid = '%@' and at_user_like_table.ishaved_review = 0 and at_user_like_table.userid != '%@' ;", uid, uid] tableName:nil];
        if (list) {
            NSDictionary *info = [list objectAtIndex:0];
            count = [[info objectForKey:@"count(*)"] integerValue];
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                @(count), @"count",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_LIKE_NOT_REVIEW_COUNT,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseSetArticleLikeStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL likeStatus = [[contentDir objectForKey:@"likeStatus"] boolValue];
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_like_table where atid='%@' and userid='%@' ", atid,uid] tableName:@"at_user_like_table"];
        if (list) {
            if (!likeStatus) {
                [[DBHelper sharedInstance] delectWithTable:@"at_user_like_table" where:[NSString stringWithFormat:@" atid='%@' and userid='%@' ", atid,uid]];
            }
        } else {
            if (likeStatus) {
                BOOL isReview = NO;
                [[DBHelper sharedInstance] insterWithTable:@"at_user_like_table" keys:@[@"atid",@"userid",@"time",@"ishaved_review"] values:@[atid,uid,@([TimeUtil getNowTimeTimest]),@(isReview)]];
                NSArray *aList = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from article_table where atid='%@'", atid] tableName:@"article_table"];
                NSDictionary *aDic = [aList objectAtIndex:0];
                NSString *uid = [aDic objectForKey:@"userid"];
                NSString *articleTitle = [aDic objectForKey:@"title"];
                [self sendNotificationMessageWithreceiveUid:uid
                                                 sendSocket:sock
                                                   protocol:IM_PROTOCOL
                                                     method:IM_NOTIFICATION_MESSAGE
                                                      title:@"有人喜欢了你的文章"
                                                    content:[NSString stringWithFormat:@"有人喜欢了你的文章：《%@》",articleTitle]];
            }
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_SET_LIKE,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseArticleDetailInfoByid:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSDictionary *detailInfo = nil;
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from article_table where atid='%@' ", atid] tableName:@"article_table"];
        if (list) {
            NSArray *relist = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from at_user_review_table where atid='%@' and userid ='%@' ", atid,uid] tableName:@"at_user_review_table"];
            if ( !relist ) {
                [[DBHelper sharedInstance] insterWithTable:@"at_user_review_table" keys:@[@"atid",@"userid",@"review_count",@"time"] values:@[atid,uid,@(1),@([TimeUtil getNowTimeTimest])]];
            } else {
                NSDictionary *dic = [relist objectAtIndex:0];
                NSInteger reviewCount = [[dic objectForKey:@"review_count"] integerValue] + 1;
                [[DBHelper sharedInstance] updateWithTable:@"at_user_review_table"
                                               keyAndVaule:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                            @(reviewCount),@"review_count",
                                                            @([TimeUtil getNowTimeTimest]),@"time",nil]
                                                     where:[NSString stringWithFormat:@" atid='%@' and userid ='%@' ", atid,uid]];
            }

            detailInfo = [list objectAtIndex:0];
        }
    }
    if (!detailInfo) {
        detailInfo = [[NSDictionary alloc] init];
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                detailInfo, @"detailInfo",
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_ID_DETAIL_INFO,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseArticleSerialDetailInfo:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    NSDictionary *detailInfo = nil;
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from tab_table where id=%lu ", tabid] tableName:@"tab_table"];
        if (list) {
            detailInfo = [list objectAtIndex:0];
        }
    }
    if (!detailInfo) {
        detailInfo = [[NSDictionary alloc] init];
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                detailInfo, @"detailInfo",
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_SERIAL_DETAIL_INFO,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}


- (void)responseArticleTopicDetialInfo:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    NSDictionary *detailInfo = nil;
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from tab_table where id=%lu ", tabid] tableName:@"tab_table"];
        if (list) {
            detailInfo = [list objectAtIndex:0];
        }
    }
    if (!detailInfo) {
        detailInfo = [[NSDictionary alloc] init];
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                detailInfo, @"detailInfo",
                                @(tag), @"tag",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_TOPIC_DETAIL_INFO,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
    
}

- (void)responseNewArticleList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSMutableArray *responseList = [[NSMutableArray alloc] init];
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    ArticleType articleType = [[contentDir objectForKey:@"articleType"] integerValue];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    
    if ( !( articleType & ArticleTypeMornal ) && !( articleType & ArticleTypeSerial )  && !( articleType & ArticleTypeTopic ) ) {
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    responseList, @"list",
                                    tag, @"tag",
                                    @"fail", @"status",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 ARTICLE_NEW_LIST,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
        [[DBHelper sharedInstance] disconnectionDB];
        return ;
    }
    
    if ([[DBHelper sharedInstance] connectionDB]) {
        // 取关注的作者的文章
        if (uid) {
            NSString *articleTypeSql = @"";
            BOOL isMornoal = NO;
            BOOL isTopic = NO;
            BOOL isSerial = NO;
            // 选取文章类型
            if ( articleType & ArticleTypeMornal ) {
                isMornoal = YES;
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeMornal]];
            }
            if ( articleType & ArticleTypeSerial ) {
                isSerial = YES;
                if (articleTypeSql.length>0) {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeSerial]];
                } else {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeSerial]];
                }
            }
            if ( articleType & ArticleTypeTopic ) {
                isTopic = YES;
                if (articleTypeSql.length>0) {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeTopic]];
                } else {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeTopic]];
                }
            }
            // 如果只有serial或topic 时 tabid起作用
            if ( !isMornoal && !isSerial && isTopic) {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid  from article_table right join atab_table on article_table.atid=atab_table.atid  where  article_table.userid in (select attentioned_userid from user_attention_table where attention_userid = '%@') and (%@) and atab_table.tabid = %lu order by article_table.createtime desc limit %lu,10;",uid , articleTypeSql, tabid,index*10] tableName:nil]];
            } else if ( !isMornoal && isSerial && !isTopic ) {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid from article_table right join atab_table on article_table.atid=atab_table.atid  where  article_table.userid in (select attentioned_userid from user_attention_table where attention_userid = '%@') and (%@) and atab_table.tabid = %lu order by article_table.createtime desc limit %lu,10;",uid , articleTypeSql, tabid,index*10] tableName:nil]];
            } else {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid from article_table right join atab_table on article_table.atid=atab_table.atid  where  article_table.userid in (select attentioned_userid from user_attention_table where attention_userid = '%@') and (%@) order by article_table.createtime desc limit %lu,10;",uid , articleTypeSql, index*10] tableName:nil]];
            }
        
        } else { // 取所有文章
            NSString *articleTypeSql = @"";
            BOOL isMornoal = NO;
            BOOL isTopic = NO;
            BOOL isSerial = NO;
            // 选取文章类型
            if ( articleType & ArticleTypeMornal ) {
                isMornoal = YES;
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeMornal]];
            }
            if ( articleType & ArticleTypeSerial ) {
                isSerial = YES;
                if (articleTypeSql.length>0) {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeSerial]];
                } else {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeSerial]];
                }
            }
            if ( articleType & ArticleTypeTopic ) {
                isTopic = YES;
                if (articleTypeSql.length>0) {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",ArticleTypeTopic]];
                } else {
                    articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",ArticleTypeTopic]];
                }
            }
            // 如果只有serial或topic 时 tabid起作用
            if ( !isMornoal && !isSerial && isTopic) {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid from article_table right join atab_table on article_table.atid=atab_table.atid  where (%@) and atab_table.tabid = %lu order by article_table.createtime desc limit %lu,10;", articleTypeSql, tabid,index*10] tableName:nil]];
            } else if ( !isMornoal && isSerial && !isTopic ) {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid from article_table right join atab_table on article_table.atid=atab_table.atid  where (%@) and atab_table.tabid = %lu order by article_table.createtime desc limit %lu,10;" , articleTypeSql, tabid,index*10] tableName:nil]];
            } else {
                [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid from article_table right join atab_table on article_table.atid=atab_table.atid  where (%@) order by article_table.createtime desc limit %lu,10;", articleTypeSql, index*10] tableName:nil]];
            }
            
        }
        
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    responseList, @"list",
                                    @(tag), @"tag",
                                    @"success", @"status",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 ARTICLE_NEW_LIST,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
        [[DBHelper sharedInstance] disconnectionDB];
        
    } else {
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    responseList, @"list",
                                    @(tag), @"tag",
                                    @"fail", @"status",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 ARTICLE_NEW_LIST,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
        [[DBHelper sharedInstance] disconnectionDB];
        
    }
}

- (void)respsonseSerialList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    [self responseTopicOrSerial:ArticleTypeSerial dataDic:dataDic socket:sock];
}

- (void)respsonseSetTab:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSInteger tabtype = [[contentDir objectForKey:@"tabtype"] integerValue];
    NSInteger tabid = [[contentDir objectForKey:@"tabid"] integerValue];
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        if ([[DBHelper sharedInstance] delectWithTable:@"atab_table" where:[NSString stringWithFormat:@"atid = '%@'",atid]] == 0) {
            [[DBHelper sharedInstance]  insterWithTable:@"atab_table" keys:@[@"atid", @"tabtype", @"tabid"] values:@[atid, @(tabtype), @(tabid)]];
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_SET_TAB,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

// 更改文章tag
- (void)respsonseSetTags:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *atid = [contentDir objectForKey:@"atid"];
    NSArray *tags = [contentDir objectForKey:@"tags"];
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        isOk = YES;
        if ([[DBHelper sharedInstance] delectWithTable:@"atag_table" where:[NSString stringWithFormat:@"atid = '%@'",atid]] == 0) {
            for ( int i=0; i < tags.count ; ++i ) {
                NSInteger tagId = [[tags objectAtIndex:i] integerValue];
                [[DBHelper sharedInstance] insterWithTable:@"atag_table" keys:@[@"atid",@"tagid"] values:@[atid, @(tagId)]];
            }
        }
    }
    NSString *status = @"fail";
    if ( isOk ) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_SET_TAGS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

// 上传文章响应
- (void)responseUpLoadArticle:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid =  [contentDir objectForKey:@"userid"];
    NSString *title =  [contentDir objectForKey:@"title"];
    NSString *body =  [contentDir objectForKey:@"body"];
    NSString *description =  [contentDir objectForKey:@"description"];
    NSInteger createtime=  [[contentDir objectForKey:@"createtime"] integerValue];
    NSString *articlepic =  [contentDir objectForKey:@"articlepic"];
    NSString *atid = [contentDir objectForKey:@"atid"];
    BOOL isOk = NO;
    if ([[DBHelper sharedInstance] connectionDB]) {
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSMutableDictionary *kvs = [[NSMutableDictionary alloc] init];
        if (uid) {
            [keys addObject:@"userid"];
            [values addObject:uid];
            [kvs setObject:uid forKey:@"userid"];
        }
        if (title) {
            [keys addObject:@"title"];
             [values addObject:title];
             [kvs setObject:title forKey:@"title"];
        }
        if (body) {
            body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            body = [body stringByReplacingOccurrencesOfString:@"file://" withString:@"http://127.0.0.1:8084/TubeBook_Web/upload"];
            body = [body stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
            [keys addObject:@"body"];
            [values addObject:body];
            [kvs setObject:body forKey:@"body"];
        }
        if (description) {
            [keys addObject:@"description"];
            [values addObject:description];
            [kvs setObject:description forKey:@"description"];
        }
        if ([contentDir objectForKey:@"createtime"]) {
            [keys addObject:@"createtime"];
            [values addObject:@(createtime)];
            [kvs setObject:@(createtime) forKey:@"createtime"];
        } else {
            [keys addObject:@"createtime"];
            [values addObject:@(0)];
            [kvs setObject:@(0) forKey:@"createtime"];
        }
        if (articlepic) {
            [keys addObject:@"articlepic"];
            [values addObject:articlepic];
            [kvs setObject:articlepic forKey:@"articlepic"];
        }
        if (atid) {
            [keys addObject:@"atid"];
            [values addObject:atid];
            //[kvs setObject:atid forKey:@"atid"];
        }
        
        if ([[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from article_table where atid='%@'", atid] tableName:@"article_table"]) {
            if ([[DBHelper sharedInstance] updateWithTable:@"article_table" keyAndVaule:kvs where:[NSString stringWithFormat:@" atid = '%@' ",atid]]) {
                isOk = YES;
            }
        } else {
            if ([[DBHelper sharedInstance] insterWithTable:@"article_table" keys:keys values:values] == 0) {
                isOk = YES;
            }
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_UPLOAD,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    

}

// 专题标题响应
- (void)responseTopicList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    [self responseTopicOrSerial:ArticleTypeTopic dataDic:dataDic socket:sock];
}

- (void)responseTopicOrSerial:(ArticleType)type dataDic:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    FouseType fouseType = [[contentDir objectForKey:@"fouseType"] integerValue];
    NSMutableArray *lists = [[NSMutableArray alloc] init];
    NSString *method = ARTICLE_TOPIC_TITLE_LIST;
    if ( type==ArticleTypeSerial ) {
        method = ARTICLE_SERIAL_TITLE_LIST;
    }
    if ([[DBHelper sharedInstance] connectionDB]) {
        if ( uid!=nil ) {
            if (fouseType == FouseTypeAttrent) {
                NSArray *tablist = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select(tabid) from user_attent_tab_table where type=%lu and userid='%@' limit %lu,15;",type,uid,index*15] tableName:@"user_attent_tab_table"];
                if (tablist) {
                    
                    for (NSDictionary *dic in tablist) {
                        NSInteger tabId = [[dic objectForKey:@"tabid"] integerValue];
                        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from tab_table where id=%lu order by (create_time) desc ;", tabId] tableName:@"tab_table"];
                        if (list) {
                            [lists addObjectsFromArray:list];
                        }
                        
                    }
                }
            } else if ( fouseType == FouseTypeCreate ) {
                NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from tab_table where type=%lu and create_userid = '%@'  order by (create_time) desc limit %lu,15;", type, uid, index*15] tableName:@"tab_table"];
                if (!list) {
                    list = [[NSArray alloc] init];
                }
                [lists addObjectsFromArray:list];
            }
        } else {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from tab_table where type=%lu order by (create_time) desc limit %lu,15;", type, index*15] tableName:@"tab_table"];
            if (!list) {
                list = [[NSArray alloc] init];
            }
            [lists addObjectsFromArray:list];
        }
        
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"success", @"status",
                                    lists, @"tabTapList",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 method,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
        [[DBHelper sharedInstance] disconnectionDB];
        return ;
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"fail", @"status",
                                lists, @"tabTapList",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             method,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

// 添加标题响应
- (void)responseAddTag:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    BOOL isOk = NO;
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *tag = [contentDir objectForKey:@"tag"];
    if ([[DBHelper sharedInstance] connectionDB]) {
        if ([[DBHelper sharedInstance] insterWithTable:@"tag_table" keys:@[@"tag"] values:@[tag]] == 0) {
            isOk = YES;
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_PROTOCOL_ADD_TAG,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

// 标签列表响应
- (void)responseTagList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger count = [[contentDir objectForKey:@"tagCount"] integerValue];
    if ([[DBHelper sharedInstance] connectionDB]) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from tag_table limit 0,%lu;",count] tableName:@"tag_table"];
        if (!list) {
            list = [[NSArray alloc] init];
        }
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"success", @"status",
                                    list, @"tagList",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 ARTICLE_PROTOCOL_TAG,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
    } else {
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"fail", @"status",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 ARTICLE_PROTOCOL, PROTOCOL_NAME,
                                 ARTICLE_PROTOCOL_TAG,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:sock data:pg.data];
    }
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)didWriteData:(GCDAsyncSocket *)sock
{
    
}

- (void)clientDidDisconnect:(GCDAsyncSocket *)sock
{
    
}

@end
