//
//  StackView.m
//
//  Version 1.0.6
//
//  Created by Nick Lockwood on 18/02/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/StackView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma clang diagnostic ignored "-Wdirect-ivar-access"
#pragma clang diagnostic ignored "-Wfloat-conversion"
#pragma clang diagnostic ignored "-Wdouble-promotion"
#pragma clang diagnostic ignored "-Wgnu"


#import "StackView.h"


@implementation StackView

- (BOOL)viewIsScrollbar:(UIView *)view
{
    if ([view isKindOfClass:[UIImageView class]])
    {
        return view.frame.size.width < 7.001 || view.frame.size.height < 7.001;
    }
    return NO;
}

- (void)setContentSpacing:(CGFloat)contentSpacing
{
    _contentSpacing = contentSpacing;
    [self setNeedsLayout];
}

- (void)setMaxHeight:(CGFloat)maxHeight
{
    _maxHeight = maxHeight;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculateContentSizeThatFits:self.frame.size andUpdateLayout:YES];
}

- (CGSize)calculateContentSizeThatFits:(CGSize)size andUpdateLayout:(BOOL)update
{
    UIEdgeInsets inset = self.contentInset;
    size.width -= (inset.left + inset.right);
    size.height -= (inset.top + inset.bottom);
    
    CGSize result = CGSizeZero;
    for (UIView *view in self.subviews)
    {
        view.autoresizingMask = UIViewAutoresizingNone;
        if (![self viewIsScrollbar:view] && !view.hidden)
        {
            CGSize _size = view.frame.size;
            if (self.autoresizesSubviews)
            {
                _size = [view sizeThatFits:size];
                _size.width = size.width;
            }
            if (update) {
                CGFloat h = _size.height;
                CGFloat w = _size.width;
                CGFloat y = _contentSpacing/2;
                CGFloat x = 0;
                
                if (view.tag < 0) {
                    h = 40;
                    y = _contentSpacing/1.5;
                    w = 200;
                    x = (result.width - 200)/2;

                    if (view.tag == -999999) {
                        h = _size.height;
                        w = _size.width;
                        y = _contentSpacing/2;
                        x = 0;
                    }
                    view.frame = CGRectMake(x, result.height - y, w, h);
                }
                else if (view.tag > 0) {
                    x = (result.width - 94)/2;
                    y = _contentSpacing/4.5;
                    w = 94;
                    view.frame = CGRectMake(x, result.height - y, w, h);
                }
                else {
                    view.frame = CGRectMake(0, result.height, _size.width, _size.height);
                }
            }

            result.height += _size.height + _contentSpacing;
            result.width = MAX(result.width, _size.width);
        }
    }
    
    result.height -= _contentSpacing;
    if (update) {
        self.contentSize = result;
    }
    result.width += inset.left + inset.right;
    result.height = MIN(_maxHeight ?: INFINITY, MAX(0.0f, result.height + inset.top + inset.bottom));
    return result;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self calculateContentSizeThatFits:size andUpdateLayout:NO];
}

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = [self calculateContentSizeThatFits:frame.size andUpdateLayout:YES];
    self.frame = frame;
}

@end
