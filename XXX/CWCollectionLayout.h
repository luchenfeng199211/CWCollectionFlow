//
//  CWCollectionLayout.h
//  CWCollectionFlow
//
//  Created by Healforce on 2017/7/7.
//  Copyright © 2017年 ChrisWei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef CGFloat(^ItemHeightBlock)(NSIndexPath *indexPath, CGFloat width);

@interface CWCollectionLayout : UICollectionViewLayout

/*
 * 列数
 */
@property (nonatomic, assign) NSInteger lineNumber;

/*
 * 行间距
 */
@property (nonatomic, assign) CGFloat rowSpacing;

/*
 * 列间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/*
 * 内边距
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;


/*
 * 通过该方法获取每个item的高度并通过block返回
 * @param block 返回一个已经计算好的item高度
 */
- (void)computeIndexCellHeightWithBlock:(CGFloat(^)(NSIndexPath *indexPath, CGFloat width))block;

@end
