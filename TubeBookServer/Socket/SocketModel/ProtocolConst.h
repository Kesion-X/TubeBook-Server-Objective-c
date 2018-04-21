
//
//  ProtocolConst.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#ifndef ProtocolConst_h
#define ProtocolConst_h

#define kMaxPacketSize 64*1024
#define SOCKET_LENGTH_BYTE_SIZE 4
#define CONTENT_LENGTH @"Content-Length"
#define PROTOCOL_NAME @"Protocol-Name"
#define PROTOCOL_METHOD @"method"
#define TAG_PROTOCOL @"Tag-Protocol"
#define ARTICLE_PROTOCOL @"Article_Protocol"
#define ARTICLE_PROTOCOL_ADD_TAG @"Add_ArticleTag"
#define ARTICLE_TOPIC_TITLE_LIST @"ArticleTopicTitleList"
#define ARTICLE_UPLOAD @"ArticleUpload"
#define ARTICLE_SET_TAGS @"AtricleSetTags"
#define ARTICLE_SET_TAB @"ArticleSetTab"
#define ARTICLE_SERIAL_TITLE_LIST @"ArticleSerialTitleList"
#define ARTICLE_NEW_LIST @"ArticleNewList"
#define ARTICLE_PROTOCOL_TAG @"ArticleTagList"
#define ARTICLE_TOPIC_DETAIL_INFO @"ArticleTopicDetailInfo"
#define ARTICLE_SERIAL_DETAIL_INFO @"ArticleSerialDetailInfo"
#define ARTICLE_ID_DETAIL_INFO @"ArticleIdDetailInfo"
#define ARTICLE_SET_LIKE @"ArticleSetLike"
#define ARTICLE_LIKE_NOT_REVIEW_COUNT @"ArticleLikeNotReviewCount"
#define ARTICLE_CREATE_TOPIC_OR_SERIAL_TAB @"ArticleCreateTopicOrSerial"
#define ARTICLE_RECOMMEND_BY_HOT_LIST @"ArticleRecommendByHotList"
#define ARTICLE_RECOMMEND_BY_USERCF_LIST @"ArticleRecommendByUserCFList"
#define ARTICLE_LIKE_STATUS @"ArticleLikeStatus" 

#define USER_PROTOCOL @"User_Protocol"
#define USER_FETCH_INFO @"UserFetchInfo"
#define USER_ATTENT_USERLIST @"UserAttentUserList"

#define IM_PROTOCOL @"IMProtocol"
// reicve_uid send_uid procotol method title content time
#define IM_NOTIFICATION_MESSAGE @"IMNotificationMessage"

#endif /* ProtocolConst_h */
