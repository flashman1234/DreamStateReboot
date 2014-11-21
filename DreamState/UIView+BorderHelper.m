//
// Created by Michal Thompson on 20/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "UIView+BorderHelper.h"

@implementation UIView (BorderHelper)

- (void)addRedBorder {
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)addGreenBorder {
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = 1;
}

@end