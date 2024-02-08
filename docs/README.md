Memory Game

## 1. Concept and Overview

This document outlines the requirements for an ASIC IP block designed to implement a memory game similar to Simon. The game involves the device playing a sequence of tones, and the player needs to repeat the sequence by pressing corresponding buttons.

## 2. Design Requirements

### 2.1 State Machine:

The state machine will control the overall flow of the game, transitioning between states like:
+ Start: Game initialization, waiting for player input.
+ Playing Sequence: Device plays a AV sequence with a short delay between each tone.
+ Player Input: Player presses buttons, and the system checks their accuracy.
+ Correct Move: If the player's move matches the sequence, advance to the next level.
+ Incorrect Move: If the player makes a mistake, provide feedback (e.g., buzzer) and restart the current level.
+ Game Over: After exceeding a predefined number of mistakes, the game ends.
The state machine should be flexible to allow for future customization of game rules (e.g., variable sequence length, different difficulty levels).

### 2.2 Tone Generation:

The IP block should include a tone generator capable of producing multiple distinct tones.
The tones should be adjustable in frequency and duration to provide an engaging game play experience.

### 2.3 Input Sampling and Debouncing:

The design should include input sampling circuitry with Debouncing Flip-Flops (DFFs) and hysteresis to eliminate switch bounce and ensure clean button press detection.

### 2.4 Memory Stack:

Implement a stack to store the sequence of tones played by the device.
The stack size should be 32 moves deep and 2 bits wide.
Push and Pop operations on the stack should be efficient and reliable.