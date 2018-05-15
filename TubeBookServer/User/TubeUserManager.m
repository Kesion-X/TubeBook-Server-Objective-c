//
//  TubeUserManager.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeUserManager.h"

@implementation TubeUserManager

- (instancetype)initTubeUserManager:(TubeServerSocketSDK *)tubeServerSocketSDK
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
    if ([protocolName isEqualToString:USER_PROTOCOL]) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *headDir = [dic objectForKey:@"head"];
        NSString *method = [headDir objectForKey:PROTOCOL_METHOD];
        if ( [method isEqualToString:USER_FETCH_INFO] ) {
            [self responseUserInfo:dic socket:sock];
        } else if ( [method isEqualToString:USER_ATTENT_USERLIST] ) {
            [self responseAttentUserList:dic socket:sock];
        } else if ( [method isEqualToString:USER_SET_ATTENT_STATUS] ) {
            [self responseSetAttentUserStatus:dic socket:sock];
        } else if ( [method isEqualToString:USER_ATTENT_STATUS] ) {
            [self responseAttentUserStatus:dic socket:sock];
        } else if ( [method isEqualToString:USER_ARTICLE_LIST] ) {
            [self responseUserArticleList:dic socket:sock];
        } else if ( [method isEqualToString:USER_USER_ATTENT_USER_COUNT] ) {
            [self requestUserAttentUserCount:dic socket:sock];
        } else if ( [method isEqualToString:USER_USER_ATTENTED_COUNT] ) {
            [self requestUserAttentedCount:dic socket:sock];
        } else if ( [method isEqualToString:USER_ATTENTED_USER_LIST] ) {
            [self requestUserAttentedUserList:dic socket:sock];
        } else if ( [method isEqualToString:USER_LIKE_ARTICLE_LIST] ) {
            [self requestUserLikeArticleList:dic socket:sock];
        } else if ( [method isEqualToString:USER_SET_AVATER] ) {
            [self requestUserSetAvater:dic socket:sock];
        } else if ( [method isEqualToString:USER_SET_THIRD_URL_COLLECTION_STATUS] ) {
            [self requestUserSetThirdUrlCollectionStatus:dic socket:sock];
        } else if ( [method isEqualToString:USER_THIRD_COLLECTION_LIST] ) {
            [self requestUserThirdCollectionList:dic socket:sock];
        }
        
        
    }
}

- (void)requestUserThirdCollectionList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSMutableArray *mlist = [[NSMutableArray alloc] init];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from user_collect_url_table where userid='%@' order by collection_time desc limit %lu,10;", uid, index*10] tableName:nil];
        if (list) {
            [mlist addObjectsFromArray:list];
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                mlist, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_THIRD_COLLECTION_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (void)requestUserSetThirdUrlCollectionStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    BOOL collectionStatus = [[contentDir objectForKey:@"collectStatus"] boolValue];
    NSString *url = [contentDir objectForKey:@"url"];
    NSString *title = [contentDir objectForKey:@"title"];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from user_collect_url_table where userid = '%@' and url = '%@';", uid, url] tableName:nil];
        if (collectionStatus && !list) { // 插入
            if ([[DBHelper sharedInstance] insterWithTable:@"user_collect_url_table" keys:@[@"userid", @"url", @"title", @"collection_time"] values:@[uid, url, title, @([TimeUtil getNowTimeTimest])]] != 0) {
                isOk = NO;
            }
        } else if (!collectionStatus && list) {// 删除
            if ([[DBHelper sharedInstance] delectWithTable:@"user_collect_url_table" where:[NSString stringWithFormat:@" userid = '%@' and url = '%@';", uid, url]] != 0) {
                isOk = NO;
            };
            
        } else {
            NSLog(@"%s not inset not delete", __func__);
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
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_THIRD_URL_COLLECTION_STATUS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestUserSetAvater:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *avater = [contentDir objectForKey:@"avater"];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        if ( [[DBHelper sharedInstance] updateWithTable:@"userinfo_table" keyAndVaule:[[NSDictionary alloc] initWithObjectsAndKeys:avater,@"avatar", nil] where:[NSString stringWithFormat:@" account = '%@' ;", uid]] != 0) {
            isOk = NO;
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
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_AVATER,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestUserLikeArticleList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select at_user_like_table.atid,title,tabtype,tabid,article_table.userid,createtime,description,articlepic from at_user_like_table "
                                                                     " left join article_table on at_user_like_table.atid = article_table.atid "
                                                                     " left join atab_table on at_user_like_table.atid = atab_table.atid "
                                                                     " where at_user_like_table.userid = '%@' limit %lu,10;", uid, index*10] tableName:nil];
        if ( list ) {
            [array addObjectsFromArray:list];
        }
        
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                array, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_LIKE_ARTICLE_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestUserAttentedUserList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from user_attention_table left join userinfo_table on user_attention_table.attention_userid = userinfo_table.account where attentioned_userid='%@' limit %lu,10;", uid, index*10] tableName:nil];
        if ( list ) {
            [array addObjectsFromArray:list];
        }
        
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                array, @"userinfoList",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENTED_USER_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestUserAttentedCount:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSInteger count = 0;
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from user_attention_table where attentioned_userid = '%@';",uid] tableName:nil];
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
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_USER_ATTENTED_COUNT,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)requestUserAttentUserCount:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    NSInteger count = 0;
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select count(*) from user_attention_table where attention_userid = '%@';",uid] tableName:nil];
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
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_USER_ATTENT_USER_COUNT,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseUserArticleList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSMutableArray *responseList = [[NSMutableArray alloc] init];
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    UserArticleType articleType = [[contentDir objectForKey:@"articleType"] integerValue];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        NSString *articleTypeSql = @"";
        // 选取文章类型
        if ( articleType & UserArticleTypeMornal ) {
            articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",UserArticleTypeMornal]];
        }
        if ( articleType & UserArticleTypeSerial ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",UserArticleTypeSerial]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",UserArticleTypeSerial]];
            }
        }
        if ( articleType & UserArticleTypeTopic ) {
            if (articleTypeSql.length>0) {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" or atab_table.tabtype=%lu ",UserArticleTypeTopic]];
            } else {
                articleTypeSql = [articleTypeSql stringByAppendingString:[NSString stringWithFormat:@" atab_table.tabtype=%lu ",UserArticleTypeTopic]];
            }
        }
    
        [responseList addObjectsFromArray:[[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select article_table.*,atab_table.tabtype,atab_table.tabid "
                                                                                       " from article_table right join atab_table on article_table.atid=atab_table.atid "
                                                                                       " where (%@) and userid='%@' order by article_table.createtime desc limit %lu,10; ", articleTypeSql, uid, index*10] tableName:nil]];
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                responseList, @"list",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ARTICLE_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
    
}

- (void)responseAttentUserStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *attentUid = [contentDir objectForKey:@"attentUid"];
    BOOL isAttent = NO;
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from user_attention_table "
                                                                     " where attention_userid = '%@' and attentioned_userid = '%@';", uid, attentUid] tableName:nil];
        if (list) {
            isAttent = YES;
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                status, @"status",
                                @(isAttent), @"isAttent", nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENT_STATUS, PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseSetAttentUserStatus:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSString *attentUid = [contentDir objectForKey:@"attentUid"];
    BOOL isAttent = [[contentDir objectForKey:@"isAttent"] boolValue];
    BOOL isOk = [[DBHelper sharedInstance] connectionDB];
    if (isOk) {
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from user_attention_table "
                                                     " where attention_userid = '%@' and attentioned_userid = '%@';", uid, attentUid] tableName:nil];
        // 设为不关注
        if (list && !isAttent) {
            [[DBHelper sharedInstance] delectWithTable:@"user_attention_table" where:[NSString stringWithFormat:@"attention_userid = '%@' and attentioned_userid = '%@'", uid, attentUid]];
        } else if (!list && isAttent) { // 设为关注
            [[DBHelper sharedInstance] insterWithTable:@"user_attention_table" keys:@[@"attention_userid",@"attentioned_userid"] values:@[uid, attentUid]];
            [self sendNotificationMessageWithreceiveUid:attentUid
                                             sendSocket:sock
                                               protocol:IM_PROTOCOL
                                                 method:IM_NOTIFICATION_MESSAGE
                                                  title:@"有人关注了你"
                                                content:[NSString stringWithFormat:@"%@ 关注了你", uid]];
        } else {
            isOk = NO;
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
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_ATTENT_STATUS,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseAttentUserList:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSInteger index = [[contentDir objectForKey:@"index"] integerValue];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select *from user_attention_table left join userinfo_table on user_attention_table.attentioned_userid = userinfo_table.account where attention_userid='%@' limit %lu,10;", uid, index*10] tableName:nil];
        if ( list ) {
            [array addObjectsFromArray:list];
        }
        
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                array, @"userinfoList",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENT_USERLIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)responseUserInfo:(NSDictionary *)dataDic socket:(GCDAsyncSocket *)sock
{
    NSDictionary *contentDir = [dataDic objectForKey:@"content"];
    NSString *uid = [contentDir objectForKey:@"uid"];
    BOOL isSelf = [[contentDir objectForKey:@"isSelf"] boolValue];
    NSInteger tag = [[contentDir objectForKey:@"tag"] integerValue];
    NSDictionary *userinfo = nil;
    BOOL isOk = NO;
    if ( [[DBHelper sharedInstance] connectionDB] ) {
        isOk = YES;
        if ( isSelf ) {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from userinfo_table where account='%@';",uid] tableName:@"userinfo_table"];
            if (list) {
                userinfo = [list objectAtIndex:0];
            }
        } else {
            NSArray *list = [[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select account,nick,description,avatar from userinfo_table where account='%@';",uid] tableName:@"userinfo_table"];
            if (list) {
                userinfo = [list objectAtIndex:0];
            }
        }
    }
    NSString *status = @"fail";
    if (isOk) {
        status = @"success";
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tag), @"tag",
                                userinfo, @"userinfo",
                                status, @"status",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_FETCH_INFO,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServerSocketSDK sendData:sock data:pg.data];
    [[DBHelper sharedInstance] disconnectionDB];
}

- (void)didWriteData:(GCDAsyncSocket *)sock
{
    
}

- (void)clientDidDisconnect:(GCDAsyncSocket *)sock
{
    
}

@end
