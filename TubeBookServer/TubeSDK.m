//
//  TubeSDK.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeSDK.h"
#import "TubeArticleManager.h"
#import "TubeUserManager.h"

@interface TubeSDK ()

@property (nonatomic, strong) TubeArticleManager *article;
@property (nonatomic, strong) TubeUserManager *userSDK;
    
@end

@implementation TubeSDK

- (instancetype)init
    {
        self = [super init];
        if (self) {
            self.tubeServerSocketSDK = [[TubeServerSocketSDK alloc] initTubeServerSocketSDK];
            self.loginSDK = [[LoginSDK alloc] initLoginSDK:self.tubeServerSocketSDK];
            self.article = [[TubeArticleManager alloc] initTubeArticleManager:self.tubeServerSocketSDK];
            self.article.loginSDK = self.loginSDK;
            [self.article openListenerData];
            self.userSDK = [[TubeUserManager alloc] initTubeUserManager:self.tubeServerSocketSDK];
            self.userSDK.loginSDK = self.loginSDK;
            [self.userSDK openListenerData];
        }
        return self;
    }
    
+ (instancetype)sharedInstance
{
    static TubeSDK *tubeSDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tubeSDK = [[TubeSDK alloc] init];
    });
    return tubeSDK;
}

@end
