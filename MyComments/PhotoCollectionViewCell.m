//
//  PhotoCollectionViewCell.m
//  MyComments
//
//  Created by Bruce on 16/1/24.
//
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell


+(instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier = @"cell0";
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    return cell;
}

-(void) layoutSubviews{
    
}


@end
