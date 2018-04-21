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
        }
    }
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
