//
//  UIImage+scale.m
//  NameCard
//
//  Created by 杨昊 on 13-1-23.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import "UIImage+scale.h"

@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
