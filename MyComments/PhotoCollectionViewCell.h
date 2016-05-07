//
//  PhotoCollectionViewCell.h
//  MyComments
//
//  Created by Bruce on 16/1/24.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface PhotoCollectionViewCell : UICollectionViewCell


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
