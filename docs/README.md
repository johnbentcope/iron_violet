# Simon't

Designing ASICs for fun and profit.

## 1. Concept and Overview

Simon't involves the device playing a sequence of tones and lighting up associated button-lamps, and the player needs to repeat the sequence by pressing corresponding buttons.

You get optimistic tune when you start a new game. If you set a new high score you get a happy tune. If you fail to set the high score, you get a sad tune. The game keeps a high score for as long as power is maintained, or until it is reset.

Each button has an associated tone that plays when being presented to the user, as well as when the user presses the buttons back into the game.

When a new game starts, the device plays a tone and button-light for a half second, and the user has to press the same button-lamp within two seconds. Then the game picks a new button-lamp from any of the four, and plays the original color and the new color for the user. The user must press the buttons in the same order they are presented. This continues until the user presses a wrong button, the user waits too long to press a button, or the game runs out of memory.

Each color in a sequence is played for the same duration, but the durations slowly shorten as the sequences get longer. This creates a sense of excitement in the user. If you fail to press the next button in a sequence in time, your game ends due to a death timeout. When you play a correct note in a sequence, the timeout for "forget" death is reset, and, if there is at least one additional color in the sequence, the timeout counts up from 0 again.

## 2. Design Requirements

### 2.1 State Machine:

The state machine SHALL control the overall flow of the game, transitioning between states.

### 2.2 Digitally Controlled Oscillator:

The oscillator loads a frequency as a counter and outputs a square wave.

It shall got a unique beep and boop to play for each button.

It shall play a lil tune when you start a game

It shall play a sad tune when you end a game and don't get a high score

It shall play a success tune when you get a high score


### 2.3 Input Sampling and Debouncing:

The design SHALL debounce input signals from button pins.

### 2.4 Internal Memory:

The ASIC SHALL maintain a high score that clears upon power cycle

### 2.5 User Interface:

The ASIC SHALL provide four inputs for push-buttons.

The ASIC SHALL provide four outputs for LEDs.

The ASIC SHall provide an audio-out for a speaker.