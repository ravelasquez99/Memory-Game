//
//  GameViewController.m
//  Memory Game
//
//  Created by Richard Velazquez on 3/28/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "GameViewController.h"
#import "Card.h"

@interface GameViewController ()



@property NSMutableArray *imageViewOutletArray;
@property (nonatomic, strong) IBOutletCollection(Card) NSMutableArray *images;
@property NSMutableArray *cards;





@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCards];
    [self shuffleCards];
    [self generateImages];
//    [self displayCardBacks];
    
}



-(void)createCards
{
    self.cards = [NSMutableArray new];
    
    for (int i = 1; i  < 17; i++) {
        
        if (i < 9) {
        Card *card1 = [Card new];
        NSString *cardImageName = [NSString stringWithFormat:@"%i",i];
        card1.cardImage = [UIImage imageNamed:cardImageName];
        card1.defaultImage = [UIImage imageNamed:@"cardBack"];
        [self.cards addObject:card1];
        }else
        {
            Card *card1 = [Card new];
            int cardInt = i - 8;
            NSString *cardImageName = [NSString stringWithFormat:@"%i",cardInt];
            card1.cardImage = [UIImage imageNamed:cardImageName];
            card1.defaultImage = [UIImage imageNamed:@"cardBack"];
            [self.cards addObject:card1];
        }
    }

}

-(void)shuffleCards
{
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

-(void)generateImages {
    for (int i =0; i <16; i++) {
        
     Card *cardImageView = [self.images objectAtIndex:i];
    Card *card = [self.cards objectAtIndex:i];
            cardImageView.image = card.defaultImage;
        cardImageView.cardImage = card.cardImage;
    }
}






- (IBAction)onImageTapped:(UITapGestureRecognizer *)sender {
    NSInteger imageTag = sender.view.tag - 1;
    Card *tappedCard = [self.images objectAtIndex:imageTag];
    NSLog(@"%@", tappedCard);
    tappedCard.image = tappedCard.cardImage;
}

- (IBAction)onShuffleCardsButtonPressed:(UIButton *)sender {
    [self shuffleCards];
}

@end
