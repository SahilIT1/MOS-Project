# 2048 Game BashScript

## Overview

This 2048 game is implemented using BashScript and offers a simple yet engaging gameplay experience. The game features a main menu where players can choose to start the game or quit. Upon starting, players are guided with instructions on how to play. During gameplay, players can control the tiles using arrow keys and perform actions like pausing, resuming, and quitting the game. The game incorporates sound effects when two tiles merge, enhancing the gaming experience.

## Features

- Main menu with options to start the game or quit.
- Instructions provided for new players.
- Graphical user interface (GUI) for entering player's name.
- Dynamic gameplay with tile movements and merges.
- Sound effects when two tiles merge.
- Pause/resume functionality during gameplay.
- Game over screen displaying final score and option to return to the main menu.
- Score tracking and saving in a text file for persistence.
- Display of highest score for players to attempt to beat.

## How to Play

1. **Main Menu**:
   - Choose "Start" to begin the game or "Quit" to exit.
   - Read instructions on how to play the game.

2. **Game Screen**:
   - Enter your name in the GUI prompt.
   - Use arrow keys to move tiles in desired direction.
   - Tiles with the same number merge when they collide.
   - Score increases as tiles merge.

3. **Pause/Resume**:
   - Press "P" to pause the game.
   - Press "R" to resume the game.

4. **Game Over**:
   - Game ends when no more tile movements are possible.
   - Final score is displayed.
   - Press "M" to return to the main menu.

5. **Highest Score**:
   - Attempt to beat the highest score displayed.
   - Score is saved in a text file for future reference.

## Repository Structure

The repository contains the following files:
- `game.sh`: The main BashScript file implementing the game logic.
- `sounds.wav`:  This sound plays once the user taps on any of the arrow keys while the game is on.
- `scores.txt`: Text file to store player scores and highest score.

## How to Run

1. Ensure BashScript is installed on your system.
2. Clone the repository to your local machine.
3. Run the `game.sh` script to start the game.
