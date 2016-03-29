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
@property int taps;
@property NSMutableArray *tappedCards;
@property NSMutableArray *cardsAsStrings;





@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCardDeck];
    [self shuffleCards];
    [self generateImages];
    self.cardsAsStrings = [NSMutableArray new];
    
}



-(void)createCardDeck
{
    self.cards = [NSMutableArray new];
    
    for (int i = 1; i  < 17; i++) {
        
        if (i < 9) {
        Card *card1 = [Card new];
        NSString *cardImageName = [NSString stringWithFormat:@"%i",i];
        card1.cardImage = [UIImage imageNamed:cardImageName];
        card1.defaultImage = [UIImage imageNamed:@"cardBack"];
        card1.imageName = cardImageName;
        [self.cards addObject:card1];
        [self.cardsAsStrings addObject:cardImageName];
        }else
        {
            Card *card1 = [Card new];
            int cardInt = i - 8;
            NSString *cardImageName = [NSString stringWithFormat:@"%i",cardInt];
            card1.cardImage = [UIImage imageNamed:cardImageName];
            card1.defaultImage = [UIImage imageNamed:@"cardBack"];
            card1.imageName = cardImageName;
            [self.cards addObject:card1];
            [self.cardsAsStrings addObject:cardImageName];

        }
    }

}

-(void)shuffleCards
{
    self.taps = 0;
    self.tappedCards = [NSMutableArray new];
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        [self.cardsAsStrings exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

-(void)generateImages {
    for (int i =0; i <16; i++) {
        Card *cardImageView = [self.images objectAtIndex:i];
        Card *card = [self.cards objectAtIndex:i];
        
        cardImageView.image = card.cardImage;
        cardImageView.cardImage = card.cardImage;
        cardImageView.imageName = card.imageName;
        card.defaultImage = [UIImage imageNamed:@"cardBack"];

    }
}



- (IBAction)onImageTapped:(UITapGestureRecognizer *)sender {
    self.taps++;
    if (self.taps == 1) {
        
        NSLog(@"this is the first tap");
        //sets the image for the card and sets its flippedbool to Yes
        NSInteger imageTag = sender.view.tag - 1;
        Card *tappedCard = [self.images objectAtIndex:imageTag];
        
        NSString *string = tappedCard.imageName;
        tappedCard.image = tappedCard.cardImage;
        tappedCard.isFlipped = YES;
    
        //adds that card to a new array
        [self.cardsAsStrings addObject:string];

    }else if (self.taps == 2){
        NSLog(@"this is the second tap");
        //sets the image for the card and sets its flippedbool to Yes
        NSInteger imageTag = sender.view.tag - 1;
        Card *tappedCard = [self.images objectAtIndex:imageTag];
        
        NSString *string = tappedCard.imageName;
        tappedCard.image = tappedCard.cardImage;
        tappedCard.isFlipped = YES;
        

        
        //adds that card to a new array
        [self.cardsAsStrings addObject:string];
        BOOL isThereAMatch = [self isThereAMatch];

    } else {self.taps = 0;}
    
    
}

-(BOOL)isThereAMatch {
    NSString *string1 = [self.cardsAsStrings objectAtIndex:0];
    NSString *string2 = [self.cardsAsStrings objectAtIndex:1];
    
    if (string1 == string2) {
        NSLog(@"we have a match");
        return YES;
    }else
    {
        NSLog(@"not a match");
        return NO;
    }
}



- (IBAction)onShuffleCardsButtonPressed:(UIButton *)sender {
    [self shuffleCards];
    [self generateImages];
    
}

@end
