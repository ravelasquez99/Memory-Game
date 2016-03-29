//
//  Card.h
//  Memory Game
//
//  Created by Richard Velazquez on 3/28/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIImageView



@property UIImage *cardImage;
@property UIImage *defaultImage;
@property NSString *imageName;
@property BOOL isFlipped;
@property BOOL isMatched;




@end
