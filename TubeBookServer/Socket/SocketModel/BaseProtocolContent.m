//
//  BaseProtocolContent.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseProtocolContent.h"

@implementation BaseProtocolContent

- (instancetype)initBaseProtocolContent:(NSData *)contentData
{
    self = [super init];
    if (self) {
        self.contentData = contentData;
    }
    return self;
}

@end
