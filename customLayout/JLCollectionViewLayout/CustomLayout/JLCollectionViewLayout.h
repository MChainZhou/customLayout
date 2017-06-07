//
//  JLCollectionViewLayout.h
//  JLCollectionViewLayout
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLCollectionViewLayout;

@protocol JLCollectionViewLayoutDelegate <NSObject>

- (CGFloat)collectionViewLayout:(JLCollectionViewLayout *)layout itemHeightAtIndexPath:(NSIndexPath *)indexpath;
@optional
- (CGSize)collectionViewLayout:(JLCollectionViewLayout *)layout sectionHeaderAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionViewLayout:(JLCollectionViewLayout *)layout sectionFooterAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface JLCollectionViewLayout : UICollectionViewLayout
/// 代理方法
@property(nonatomic, weak) id<JLCollectionViewLayoutDelegate>delegate;
/// 内边距
@property (nonatomic,assign) UIEdgeInsets sectionInsets;
/// 每一行之间的距离
@property (nonatomic,assign) CGFloat rowMargin;
/// 每一列之间的距离
@property (nonatomic,assign) CGFloat columnMargin;
/// 显示多少列
@property (nonatomic,assign) NSUInteger numberOfColumn;
@end
