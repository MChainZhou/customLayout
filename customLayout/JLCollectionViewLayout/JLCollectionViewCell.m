//
//  JLCollectionViewCell.m
//  JLCollectionViewLayout
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JLCollectionViewCell.h"

@interface JLCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation JLCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.bgView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    self.bgView.backgroundColor = [UIColor redColor];
}

@end
