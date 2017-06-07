//
//  JLCollectionViewLayout.m
//  JLCollectionViewLayout
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JLCollectionViewLayout.h"

@interface JLCollectionViewLayout ()
/// 布局属性
@property (nonatomic,strong) NSMutableArray *attrArr;
/// 每一列的高度
@property (nonatomic,strong) NSMutableArray *maxYArr;
/// 记录当前布局的section的位置
@property (nonatomic,assign) NSInteger section;
@end

@implementation JLCollectionViewLayout

- (instancetype)init{
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.numberOfColumn = 2;
        self.section = 0;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    // 清空数组中的元素
    [self.attrArr removeAllObjects];
    [self.maxYArr removeAllObjects];
    self.maxYArr = nil;
    self.attrArr = nil;
    self.section = 0;
    
    // 计算cell的属性
    NSInteger sections = self.collectionView.numberOfSections;
    for (int i = 0; i < sections; i ++) {
        //1.计算section header的属性
        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [self.attrArr addObject:headerAttr];
        //2.设置maxY的值（防止出现下一个section多出self.rowMargin）
//        if (i != 0) {
//            [self setupMaxY];
//        }
        //3.计算所有item的属性
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j ++) {
            UICollectionViewLayoutAttributes *itemAttri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [self.attrArr addObject:itemAttri];
        }
        //4.计算section footer的属性
        UICollectionViewLayoutAttributes *footerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [self.attrArr addObject:footerAttr];
    }
    
}

- (void)setupMaxY{
    for (NSInteger i = 0; i < self.numberOfColumn; i ++) {
        self.maxYArr[i] = @([self.maxYArr[i] floatValue] - self.rowMargin);
    }
}
// 返回indexPath位置上的item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 找出最短的那列
    NSInteger column = self.minYColumn;
    
    //1.计算item的宽
    CGFloat itemW = (self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right - (self.numberOfColumn - 1) * self.columnMargin)/self.numberOfColumn;
    CGFloat itemH = [self.delegate collectionViewLayout:self itemHeightAtIndexPath:indexPath];
    CGFloat itemX = self.sectionInsets.left + (self.columnMargin + itemW) * column;
    CGFloat itemY = [self.maxYArr[column] floatValue] + self.rowMargin;
    
    // 更新这一列的最大值
    self.maxYArr[column] = @(itemY + itemH);
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(itemX, itemY, itemW, itemH);
    return attri;
}

/// 返回头视图和尾部视图的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self attributesForHeadetAtIndexPath:indexPath];
    }else{
        return [self attributesForFooterAtIndexPath:indexPath];
    }
}
/// 返回rect内的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *resultArrM = [NSMutableArray array];
    [self.attrArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes* attr, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [resultArrM addObject:attr];
        }
    }];
    
    return self.attrArr;
}
/// 返回collectionView的尺寸
- (CGSize)collectionViewContentSize{
    CGSize contentSize = CGSizeZero;
    
    // 假设最长的一列示第0列
    __block NSInteger maxColumn = 0;
    [self.maxYArr enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([number floatValue] > [self.maxYArr[maxColumn] floatValue]) {
            maxColumn = idx;
        }
    }];
    contentSize = CGSizeMake(0, [self.maxYArr[maxColumn] floatValue]);
    
    return contentSize;
}

#pragma mark --- set方法
- (void)setRowMargin:(CGFloat)rowMargin{
    _rowMargin = rowMargin;
    [self invalidateLayout];
}

- (void)setColumnMargin:(CGFloat)columnMargin{
    _columnMargin = columnMargin;
    [self invalidateLayout];
}
- (void)setNumberOfColumn:(NSUInteger)numberOfColumn{
    _numberOfColumn = numberOfColumn ;
    [self invalidateLayout];
}
- (void)setSectionInsets:(UIEdgeInsets)sectionInsets{
    _sectionInsets = sectionInsets;
    [self invalidateLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

#pragma mark --- 私有方法
/// 获得Y值最小的列
- (NSInteger)minYColumn{
    __block NSInteger minColumn = 0;
    __block CGFloat minHeight = CGFLOAT_MAX;
    [self.maxYArr enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat heightInArray = [self.maxYArr[idx] floatValue];
        if (heightInArray < minHeight) {
            minHeight = heightInArray;
            minColumn = idx;
        }
    }];
    
    return minColumn;
}

/// 获得当前组最大的y值
- (CGFloat)maxYColumn{
    __block NSInteger maxColumn = 0;
    [self.maxYArr enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.maxYArr[maxColumn] floatValue]) {
            maxColumn = idx;
        }
    }];
    
    return [self.maxYArr[maxColumn] floatValue];;
}

- (UICollectionViewLayoutAttributes *)attributesForHeadetAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    CGSize headerSize = [self headerSizeAtIndexPath:indexPath];
    CGFloat x = (self.collectionView.frame.size.width - headerSize.width)/2;
    // 获得当前组最大的y值
    CGFloat maxY = [self maxYColumn];
    attr.frame = CGRectMake(x, maxY + self.sectionInsets.top, headerSize.width, headerSize.height);
    //将下一组的初始值y更新
    [self updateMaxY:CGRectGetMaxY(attr.frame)];
    
    return attr;
}



- (UICollectionViewLayoutAttributes *)attributesForFooterAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    CGSize footerSize = [self footerSizeAtIndexPath:indexPath];
    CGFloat x = (self.collectionView.frame.size.width - footerSize.width ) / 2;
    // 获得当前组最大的y值
    CGFloat maxY = [self maxYColumn];
    
    attr.frame = CGRectMake(x, maxY + self.sectionInsets.bottom, footerSize.width, footerSize.height);
    //将下一组的初始值y更新
    CGFloat newMaxY = CGRectGetMaxY(attr.frame);
    [self updateMaxY:newMaxY];
    return attr;
}

- (void)updateMaxY:(CGFloat)maxY{
    for (NSInteger i = 0; i < self.maxYArr.count; i ++) {
        self.maxYArr[i] = @(maxY);
    }
}

- (CGSize)headerSizeAtIndexPath:(NSIndexPath *)indexPath{
    CGSize headerSize = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(collectionViewLayout:sectionHeaderAtIndexPath:)]) {
        headerSize = [self.delegate collectionViewLayout:self sectionHeaderAtIndexPath:indexPath];
    }
    
    return headerSize;
}

- (CGSize)footerSizeAtIndexPath:(NSIndexPath *)indexPath{
    CGSize footerSize = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(collectionViewLayout:sectionFooterAtIndexPath:)]) {
        footerSize = [self.delegate collectionViewLayout:self sectionFooterAtIndexPath:indexPath];
    }
    
    return footerSize;
}

#pragma mark --- 懒加载
- (NSMutableArray *)attrArr{
    if (!_attrArr) {
        _attrArr = [NSMutableArray array];
    }
    return _attrArr;
}

- (NSMutableArray *)maxYArr{
    if (!_maxYArr) {
        _maxYArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < self.numberOfColumn; i ++) {
            
            [_maxYArr addObject:@(self.sectionInsets.top)];
        }
    }
    return _maxYArr;
}

@end
