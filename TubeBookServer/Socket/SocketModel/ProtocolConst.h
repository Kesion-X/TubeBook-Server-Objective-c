
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
#define ARTICLE_TAB_LIKE_STATUS @"ArticleTabLikeStatus"
#define ARTICLE_TAB_SET_LIKE @"ArticleTabSetLike"
#define ARITCLE_USER_LIKE_LIST @"ArticleUserLikeList"
#define ARTICLE_COMMENT_TO_USER @"ArticleCommentToUser"
#define ARTICLE_COMMENT_LIST @"AricleCommentList"
#define ARTICLE_USER_COMMENT_TO_USER @"ArticleUserCommentToUser"
#define ARTICLE_USER_COMMENT_TO_USER_LIST @"ArticleUserCommentToUserList"
#define ARTICLE_COMMENT_NOT_REVIEW_COUNT @"ArticleCommentNotReviewCount"
#define ARTICLE_RECEIVE_COMMENT_LIST @"ArticleReceiveCommentList"
#define ARTICLE_COMMENT_FROM_USER_TO_USER_LIST @"ArticleCommentFromUserToUserList"
#define ARTICLE_COMMENT_BY_CID @"ArticleCommentByCid"
#define ARTICLE_SET_COMMENT_REVIEW_STATUS @"ArticleSetCommentReviewStatus"
#define ARTICLE_RECEIVE_USER_LIKE_ARTICLE_LIST @"ArticleReceiveUserLikeArticleList"
#define ARTICLE_USER_CREATE_ARTICLE_COUNT @"ArticleUserCreateArticleCount"


#define USER_PROTOCOL @"User_Protocol"
#define USER_FETCH_INFO @"UserFetchInfo"
#define USER_ATTENT_USERLIST @"UserAttentUserList"
#define USER_SET_ATTENT_STATUS @"UserSetAttentStatus"
#define USER_ATTENT_STATUS @"UserAttentStatus"
#define USER_ARTICLE_LIST @"UserArticleList"
#define USER_USER_ATTENT_USER_COUNT @"UserUserAttentUserCount"
#define USER_USER_ATTENTED_COUNT @"UserUserAttentedCount"
#define USER_ATTENTED_USER_LIST @"UserAttentedUserList"
#define USER_LIKE_ARTICLE_LIST @"UserLikeArticleList"
#define USER_SET_AVATER @"UserSetAvater"
#define USER_SET_THIRD_URL_COLLECTION_STATUS @"UserSetThirdUrlCollectionStatus"
#define USER_THIRD_COLLECTION_LIST @"UserThirdCollectionList"

#define IM_PROTOCOL @"IMProtocol"
// reicve_uid send_uid procotol method title content time
#define IM_NOTIFICATION_MESSAGE @"IMNotificationMessage"

#endif /* ProtocolConst_h */
