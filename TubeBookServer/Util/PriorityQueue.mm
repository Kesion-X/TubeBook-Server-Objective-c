//
//  PriorityQueue.mm
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "PriorityQueue.h"
#include <queue>

class QueueCompare {
public:
    bool operator()(QueueIntNodeObject *l, QueueIntNodeObject *r) const {
        if (l.compareValue < r.compareValue) {
            return true;
        }else {
            return false;
        }
    }
};

typedef std::priority_queue<QueueIntNodeObject *, std::vector<QueueIntNodeObject *>, QueueCompare> Queue;

#pragma mark - QueueIntNodeObject
@implementation QueueIntNodeObject
@end


@interface PriorityQueue ()

@property (nonatomic) Queue *priority_queue;

@end

@implementation PriorityQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _priority_queue = new Queue();
    }
    return self;
}

- (void)dealloc {
    delete _priority_queue;
    _priority_queue = NULL;
}

- (QueueIntNodeObject *)topObject {
    return !self.priority_queue->empty() ? self.priority_queue->top() : nil;
}

- (NSUInteger)count {
    return (NSUInteger)self.priority_queue->size();
}

- (void)popObject {
    if (!self.priority_queue->empty()) {
        self.priority_queue->pop();
    }
}

- (void)pushObject:(QueueIntNodeObject *)myObject {
    self.priority_queue->push(myObject);
}

- (void)popAllObjects {
    if (!self.priority_queue->empty()) {
        delete _priority_queue;
        _priority_queue = new Queue();
    }
}

@end
