//
//  CFScratchView.h
//  CFScratchView
//
//  Created by 于传峰 on 16/6/6.
//  Copyright © 2016年 于传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFScratchView : UIView

- (instancetype)initWithImage:(UIImage *)image coverImage:(UIImage *)coverImage;

- (void)recover;
@end
