//
//  UserSimilarity.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSimilarity : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) CGFloat similarityPrice;

- (instancetype)initUserSimilarityWithUid:(NSString *)uid similarityPrice:(CGFloat)similarityPrice;

@end
