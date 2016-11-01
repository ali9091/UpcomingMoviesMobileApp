//
//  CALayer+XibConfiguration.m
//  Nin60
//
//  Created by Ali Ehsan on 7/3/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
