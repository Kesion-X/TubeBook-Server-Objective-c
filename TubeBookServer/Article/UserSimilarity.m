//
//  UserSimilarity.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UserSimilarity.h"

@implementation UserSimilarity

- (instancetype)initUserSimilarityWithUid:(NSString *)uid similarityPrice:(CGFloat)similarityPrice
{
    self = [self init];
    if (self) {
        self.uid = uid;
        self.similarityPrice = similarityPrice;
    }
    return self;
}

@end
