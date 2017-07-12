//
//  CWCollectionLayout.m
//  CWCollectionFlow
//
//  Created by Healforce on 2017/7/7.
//  Copyright © 2017年 ChrisWei. All rights reserved.
//

#import "CWCollectionLayout.h"

@interface CWCollectionLayout ()
{
    NSMutableDictionary         *_dicOfHeight;      //存放每列高度字典
    NSMutableArray              *_itemAttrubutes;   //存放indexPath的数组
    ItemHeightBlock             _heightBlock;       //接收返回的item高度
}
@end

@implementation CWCollectionLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

/*
 * 初始化所需要的属性
 */
- (void)initData
{
    self.lineNumber = 2;
    self.rowSpacing = 10.0f;
    self.lineNumber = 10.0f;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _dicOfHeight = [[NSMutableDictionary alloc] init];
    _itemAttrubutes = [[NSMutableArray alloc] init];
}

/*
 * 调用顺序：1
 * 准备对item进行布局时会调用此方法
 */
- (void)prepareLayout
{
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //初始化每列的高度
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_itemAttrubutes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

/*
 * 调用顺序：2
 * 设置可滚动的区域范围
 * @return 可滚动的Size大小
 */
- (CGSize)collectionViewContentSize
{
    __block NSString *maxHeightLine = @"0";
    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[maxHeightLine] floatValue] < [obj floatValue]) {
            maxHeightLine = key;
        }
    }];
    return CGSizeMake(self.collectionView.bounds.size.width, [_dicOfHeight[maxHeightLine] floatValue] + self.sectionInset.bottom);
}

/*
 * 调用顺序：3
 * @return 返回时图框内item的属性，可以直接返回所有的item属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _itemAttrubutes;
}

/*
 * 计算indexPath下每个item的属性
 * @return 返回对应于indexPath的位置的cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber;
    CGFloat itemH = 0.0;
    //计算item的高度
    if (_heightBlock != nil) {
        itemH = _heightBlock(indexPath, itemW);
    } else {
        NSAssert(itemH != 0,@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    //计算item的frame
    CGRect frame;
    frame.size = CGSizeMake(itemW, itemH);
    
    __block NSString *lineMinHeight = @"0";
    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];
    
    frame.origin = CGPointMake(self.sectionInset.left + line * (itemW + self.lineSpacing), [_dicOfHeight[lineMinHeight] floatValue]);
    _dicOfHeight[lineMinHeight] = @(frame.size.height + self.rowSpacing + [_dicOfHeight[lineMinHeight] floatValue]);
    attr.frame = frame;
    
    return attr;
}

/*
 * @param block 计算item高度的block
 */
- (void)computeIndexCellHeightWithBlock:(CGFloat (^)(NSIndexPath *, CGFloat))block
{
    if (_heightBlock != block) {
        _heightBlock = block;
    }
}

@end
