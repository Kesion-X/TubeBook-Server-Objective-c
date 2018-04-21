//
//  TubeAddress.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeAddress.h"

@implementation TubeAddress

- (instancetype)initWithHost:(NSString *)host andPort:(uint16_t)port
{
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
    }
    
    return self;
}

@end
