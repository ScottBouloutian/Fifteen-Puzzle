Fifteen-Puzzle
==============
 An iOS app to play and solve the classic 15 Puzzle.
 Uses Cocos2D for the graphics (app was made before iOS7 SpriteKit)

Implementation
---------------
 This solver uses IDA* with an additive pattern database to contruct the heuristic. This was implemented as described in the paper:
 http://www.jair.org/media/1480/live-1480-2332-jair.pdf
