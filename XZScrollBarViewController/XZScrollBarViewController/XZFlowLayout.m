//
//  XZFlowLayout.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/11.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZFlowLayout.h"

@implementation XZFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    if (self.collectionView.bounds.size.height) {
        self.itemSize = self.collectionView.bounds.size;
    }
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    
}
@end
