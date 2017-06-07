//
//  JLCellModel.m
//  JLCollectionViewLayout
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JLCellModel.h"

@implementation JLCellModel
- (CGFloat)cellH{
    if (!_cellH) {
        _cellH = 200 + arc4random_uniform(40);
    }
    return _cellH;
}
@end
