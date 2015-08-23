# OmahaOddsCalculator
This application calculate the odds between two hands given board in Omaha poker.

the value of card is below : A, 2,3,4,5,6,7,8,9, T,J,Q,K 
the color of dec is below : s-spade, h-heart, c-clubs, d-diamond.

Some hand examples:  AcAh7s8d    or   6s7s8h9s  (six of spade, seven of spade, eight of heart and 9 of spade)

The board could be three ways: 
-if you leave blank, it calculates the pre-flop odds.
-if you specify 3 cards(flop),e.g., ‘5s6h7d’, it calculates the flop odds.
-if you specify 4 cards(turn),e.g., ‘2d2h7s8d’, it calculates the turn odds.

More details on Omaha poker could be checked in :
"https://en.wikipedia.org/wiki/Omaha_hold_%27em"