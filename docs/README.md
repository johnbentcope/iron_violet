# Simon't

Designing ASICs for fun and profit.

## 1. Concept and Overview

Simon involves the device playing a sequence of tones and lighting up associated button lamps, and the player needs to repeat the sequence by pressing corresponding buttons. It keeps a high score for as long as power is maintained. If you set a new high score you get happy music. If you fail to set the high score, you get sad sound. You get optimistic tune when you start a new game. A new game plays a tone/light for a half second, and you have to play it back within two seconds. The time for a move decreases at some rate TBD. When you play a correct note in a sequence, the timeout for "forget" death is reset. If you complete a sequence without death timeout, a PRNG picks a new buttonlamp for you to have to remember, and the game plays the full sequence in order with the new buttonlamp added at the end.

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