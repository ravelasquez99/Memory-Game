//
//  GameViewController.m
//  Memory Game
//
//  Created by Richard Velazquez on 3/28/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//


//alt: performselector afteterdelay

#import "GameViewController.h"
#import "Card.h"

#pragma Properties
//setting up the match counter and making it reset on shuffle
@interface GameViewController ()

//default properties for gameflow to work
@property (nonatomic, strong) IBOutletCollection(Card) NSMutableArray *images;
@property NSMutableArray *cards;

//Properties tracking User interaction
@property int taps;
@property Card *tappedCard1;
@property Card *tappedCard2;
@property (weak, nonatomic) IBOutlet UILabel *matchCounter;

//"scorekeeping properties"
@property NSMutableArray *cardsAsStrings;
@property BOOL isThereAMatch;
@property int matches;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property int seconds;
@property int finalTime;
@property int topScore;



//user defaults call
@property NSUserDefaults *defaults;
@property int score;


@end

@implementation GameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCardDeck];
    [self shuffleCards];
    [self generateImages];
    self.matches = 0;
    
    //timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTimerLabel)
                                   userInfo:nil
                                    repeats:YES];
    
}


//resets the card deck to a new deck. adds the cards image name, default image name (the card back), the imageName string. It then adds the image name string to a new string so I can check more easily for matches later


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

//shuffles the cards image order and the cardsAsStrings array in the exact same way
-(void)shuffleCards
{
    [self createCardDeck];
    [self generateImages];
    [self resetUserIneractionEnabled];
    self.taps = 0;
    self.matches = 0;
    self.matchCounter.text = @"Matches 0";
    self.seconds = 0;
    
    
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        [self.cardsAsStrings exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

//generates the images in a different array. forgot why I needed to do that but there was a reason lol
-(void)generateImages {
    for (int i =0; i <16; i++) {
        Card *cardImageView = [self.images objectAtIndex:i];
        Card *card = [self.cards objectAtIndex:i];
        
        cardImageView.image = card.defaultImage;
        cardImageView.cardImage = card.cardImage;
        cardImageView.imageName = card.imageName;
        card.defaultImage = [UIImage imageNamed:@"cardBack"];

    }
}


//tracks taps (by default set to 0) so that on the first tap it doesn't run the test and on the second it runs the test match set locks the images and resets the tap. Also needs to trigger the label for count of matches to change.
- (IBAction)onImageTapped:(UITapGestureRecognizer *)sender {
    self.taps++;
    if (self.taps == 1) {
        
        NSLog(@"this is the first tap");
        //sets the imageTag for the card and removes the ability to tap it
        NSInteger imageTag = sender.view.tag - 1;
        Card *tappedCard = [self.images objectAtIndex:imageTag];
        [tappedCard setUserInteractionEnabled:NO];
        
        //adds the card to tapped card1 and removes the ability to tap it again
        self.tappedCard1 = tappedCard;
        
        
        NSString *string = tappedCard.imageName;
        tappedCard.image = tappedCard.cardImage;
        tappedCard.isFlipped = YES;
    
        //adds that card name to a new array for the match check
        [self.cardsAsStrings addObject:string];

    }else if (self.taps == 2){
        self.taps = 0;
        NSLog(@"this is the second tap");
        
        //sets the imageTag for the card and sets its flippedbool to Yes
        NSInteger imageTag = sender.view.tag - 1;
        Card *tappedCard = [self.images objectAtIndex:imageTag];
        
        self.tappedCard2 = tappedCard;

        
        NSString *string = tappedCard.imageName;
        tappedCard.image = tappedCard.cardImage;
        tappedCard.isFlipped = YES;
        

        
        //adds that card to a new array
        [self.cardsAsStrings addObject:string];
       self.isThereAMatch = [self matchCheck];
        
        //checks match logic. if there is a match we say there is a match and reset the cardsAsStrings
        if (self.isThereAMatch) {
            [self.tappedCard1 setUserInteractionEnabled:NO];
            [self.tappedCard2 setUserInteractionEnabled:NO];
            self.cardsAsStrings = [NSMutableArray new];
        } else {
            self.tappedCard1.image = [UIImage imageNamed:@"cardBack"];
            self.tappedCard2.image = [UIImage imageNamed:@"cardBack"];
            [self.tappedCard1 setUserInteractionEnabled:YES];
            [self.tappedCard2 setUserInteractionEnabled:YES];//I know I don't need this. It just helps me proccess what is happening

            self.cardsAsStrings = [NSMutableArray new];
            }
        
        if (self.matches == 8) {

            [self alertWin];
        }
    }//ends 2nd tap routine
        
        //trigger label change for count
        //check for game end
        //trigger game end logic
}

-(BOOL)matchCheck {
    NSString *string1 = [self.cardsAsStrings objectAtIndex:0];
    NSString *string2 = [self.cardsAsStrings objectAtIndex:1];
    
    if (string1 == string2) {
        NSLog(@"we have a match");
        self.matches++;
        self.matchCounter.text = [NSString stringWithFormat:@"Matches: %i", self.matches];
        return YES;
    }else
    {
        NSLog(@"not a match");
        return NO;
    }
}

-(void)updateTimerLabel {
    self.seconds++;
    self.timer.text = [NSString stringWithFormat:@"Time:%i",self.seconds];
    
}


-(void)alertWin {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You Won!" message:@"You got every match" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *playAgain = [UIAlertAction actionWithTitle:@"You Won!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                { [self shuffleCards];}];
    
    [alert addAction:playAgain];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onShuffleCardsButtonPressed:(UIButton *)sender {
    
    [self shuffleCards];
    
}

-(void)resetUserIneractionEnabled {
    for (Card *card in self.images) {
        [card setUserInteractionEnabled:YES];
    }
}



@end
