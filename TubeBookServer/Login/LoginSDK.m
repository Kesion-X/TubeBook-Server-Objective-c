//
//  LoginSDK.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/2.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "LoginSDK.h"
#import "LoginManager.h"

@interface LoginSDK ()

@property (nonatomic, strong) LoginManager *loginMgr;
    
@end

@implementation LoginSDK

- (instancetype)initLoginSDK:(TubeServerSocketSDK *)tubeServerSocketSDK;
{
    self = [super init];
    if (self) {
        self.loginMgr = [[LoginManager alloc] initLoginManager:tubeServerSocketSDK];
    }
    return self;
}
    
- (void)openListenerData
{
    [self.loginMgr openListenerData];
}

- (void)closeListenerData
{
    [self.loginMgr closeListenerData];
}
// 获取某用户socket
- (GCDAsyncSocket *)getSocketByUserid:(NSString *)uid
{
    return [self.loginMgr getSocketByUserid:uid];
}

- (NSString *)getUserIdBySocket:(GCDAsyncSocket *)socket
{
    return [self.loginMgr getUserIdBySocket:socket];
}


@end
