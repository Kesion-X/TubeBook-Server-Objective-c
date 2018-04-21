//
//  LoginManager.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/2.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "LoginManager.h"
#import "TubeServerSocketSDK.h"
#import "DBHelper.h"
#import "BaseSocketPackage.h"

@interface LoginManager () <TubeServerDeletage>

@property (nonatomic, strong) TubeServerSocketSDK *tubeServerSocketSDK;
@property (nonatomic, strong) NSMutableDictionary *socketMap;

@end

@implementation LoginManager
    
- (instancetype)initLoginManager:(TubeServerSocketSDK *)tubeServerSocketSDK
{
    self = [super init];
    if (self) {
        self.tubeServerSocketSDK = tubeServerSocketSDK;
    }
    return self;
}
    
- (void)openListenerData
{
    if (self.tubeServerSocketSDK) {
        [self.tubeServerSocketSDK addProcotolListener:self];
    }
}

- (void)closeListenerData
{
    if (self.tubeServerSocketSDK) {
        [self.tubeServerSocketSDK removeProcotolListener:self];
    }
}

- (GCDAsyncSocket *)getSocketByUserid:(NSString *)uid
{
    return [self.socketMap objectForKey:uid];
}

- (NSString *)getUserIdBySocket:(GCDAsyncSocket *)socket
{
    NSString *uid = nil;
    for (NSString *key in  self.socketMap.allKeys) {
        GCDAsyncSocket *s = [self.socketMap objectForKey:key];
        if ( s == socket ) {
            uid = key;
            break;
        }
    }
    return uid;
}

#pragma mark - delegate
- (void)acceptNewClient:(GCDAsyncSocket *)sock
{
    
}
    
- (void)didReadData:(GCDAsyncSocket *)sock didReadData:(NSData *)data protocolName:(NSString *)protocolName
{
    if ([protocolName isEqualToString:@"Login"]) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *contentDic = [dic objectForKey:@"content"];
        NSString *account = [contentDic objectForKey:@"account"];
        NSString *pass = [contentDic objectForKey:@"pass"];
        if ([[DBHelper sharedInstance] connectionDB]) {
            NSLog(@"%@ %@",account,pass);
           
            if ([[DBHelper sharedInstance] fetchQuerySelect:[NSString stringWithFormat:@"select * from ap_table where account = '%@' and pass = '%@'",account,pass] tableName:@"ap_table"]) {
                BaseSocketPackage *pg = [self loginStatePg:@"success"];
                [self.socketMap setObject:sock forKey:account];
                [self.tubeServerSocketSDK sendData:sock data:pg.data];
            } else {
                BaseSocketPackage *pg = [self loginStatePg:@"fall"];
                [self.tubeServerSocketSDK sendData:sock data:pg.data];
            }
            [[DBHelper sharedInstance] disconnectionDB];
        }
    }
}
    
- (BaseSocketPackage *)loginStatePg:(NSString *)state
{
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"Login", PROTOCOL_NAME,
                             nil];
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                state, @"State-Login",
                                nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    return pg;
}
    
- (void)didWriteData:(GCDAsyncSocket *)sock
{

}
    
- (void)clientDidDisconnect:(GCDAsyncSocket *)sock
{
    for (NSString *key in self.socketMap.allKeys) {
        GCDAsyncSocket *s = [self.socketMap objectForKey:key];
        if (sock == s) {
            [self.socketMap removeObjectForKey:s];
            break;
        }
    }
}

#pragma mark - get
- (NSMutableDictionary *)socketMap
{
    if (!_socketMap) {
        _socketMap = [[NSMutableDictionary alloc] init];
    }
    return _socketMap;
}

@end
