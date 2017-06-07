//
//  ViewController.m
//  JLCollectionViewLayout
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "JLCollectionViewCell.h"
#import "JLCollectionViewLayout.h"
#import "JLCellModel.h"

static NSString *const cellID = @"cellID";
static NSString *const header = @"header";
static NSString *const footer = @"footer";
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JLCollectionViewLayoutDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header forIndexPath:indexPath];
        [reusableView addSubview:[self contantHeaderView]];
        return reusableView;
    }else{
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer forIndexPath:indexPath];
        [reusableView addSubview:[self contantFooterView]];
        return reusableView;
    }
}

- (UIView *)contantHeaderView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (UIView *)contantFooterView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

#pragma mark --- JLCollectionViewLayoutDelegate
- (CGFloat)collectionViewLayout:(JLCollectionViewLayout *)layout itemHeightAtIndexPath:(NSIndexPath *)indexpath{
    JLCellModel *model = self.dataSource[indexpath.item];
    return model.cellH;
}

- (CGSize)collectionViewLayout:(JLCollectionViewLayout *)layout sectionHeaderAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, 200);
}
- (CGSize)collectionViewLayout:(JLCollectionViewLayout *)layout sectionFooterAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, 100);
}


#pragma mark --- 懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        JLCollectionViewLayout *layout = [[JLCollectionViewLayout alloc]init];
        layout.delegate = self;
        layout.numberOfColumn = 2;
        layout.rowMargin = 10;
        layout.columnMargin = 10;
        layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JLCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < 20; i ++) {
            JLCellModel *model = [[JLCellModel alloc]init];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

@end
