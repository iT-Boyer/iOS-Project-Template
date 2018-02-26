//
//  ZYModalPresentSegue.h
//  Very+
//
//  Created by BB9z on 7/12/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "MBModalPresentSegue.h"

@interface ZYModalPresentSegue : RFSegue

@end

@interface ZYModalPresentContainer : UIViewController <
    MBModalPresentSegueDelegate,
    UIGestureRecognizerDelegate
>
@property (nonatomic) BOOL hidden;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containedViewHolder;

- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

@end
