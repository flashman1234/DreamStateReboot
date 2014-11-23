//
// Created by Michal Thompson on 23/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "RecordingImageView.h"


@implementation RecordingImageView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *myImage2 = [UIImage imageNamed:@"recording_image"];
        self.myImage = myImage2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    float colour = self.passedInValue;

    float size = ((self.passedInValue * 40) + 1) * 8;
    float theAlpha = 1;
    if (size < 20) {
        theAlpha = 0.8;
    }

    if (size < 15) {
        theAlpha = 0.6;
    }

    if (size < 10) {
        theAlpha = 0.5;
    }

    CGContextSetCMYKFillColor(context, 0.2, colour, colour, 0, theAlpha);
    CGContextFillRect(context, CGRectMake((((self.frame.size.width / 2) - (size / 2))) + 5, (((self.frame.size.height / 2) - (size / 2))) + 5, (size) - 10, (size) - 10));

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    CGRect imageRect = CGRectMake(((width / 2) - (size / 2)) - 10, ((height / 2) - (size / 2)) - 10, size + 20, size + 20);
    [self.myImage drawInRect:imageRect];

}
@end