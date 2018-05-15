//
//  CKContent.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKContent.h"

@implementation CKContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataType = [[CKDataType alloc] init];
    }
    return self;
}

- (NSString *)description
{
    return self.serialTitle;
}

@end
