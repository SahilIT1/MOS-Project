#!/bin/env python3

import curses
import random
import pygame
import tkinter as tk
from tkinter import simpledialog

def init_sound():
    pygame.mixer.init()
    sound = pygame.mixer.Sound("2048sound.wav")  # Change "2048sound.wav" to the actual filename
    return sound

def initialize_board():
    return [[0] * 4 for _ in range(4)]

def add_new_tile(board):
    empty_tiles = [(i, j) for i in range(4) for j in range(4) if board[i][j] == 0]
    if empty_tiles:
        i, j = random.choice(empty_tiles)
        board[i][j] = 2 if random.random() < 0.9 else 4

def move_left(board, sound):
    score = 0
    for row in board:
        for i in range(3):
            if row[i] == row[i + 1] and row[i] != 0:
                row[i] *= 2
                score += row[i]
                row[i + 1] = 0
                sound.play()  # Play sound when two tiles merge
        shifted_row = [cell for cell in row if cell != 0]
        shifted_row += [0] * (4 - len(shifted_row))
        row[:] = shifted_row
    return score

def move_right(board, sound):
    score = 0
    for row in board:
        for i in range(3, 0, -1):
            if row[i] == row[i - 1] and row[i] != 0:
                row[i] *= 2
                score += row[i]
                row[i - 1] = 0
                sound.play()  # Play sound when two tiles merge
        shifted_row = [cell for cell in row if cell != 0]
        shifted_row = [0] * (4 - len(shifted_row)) + shifted_row
        row[:] = shifted_row
    return score

def move_up(board, sound):
    score = 0
    for j in range(4):
        column = [board[i][j] for i in range(4)]
        for i in range(3):
            if column[i] == column[i + 1] and column[i] != 0:
                column[i] *= 2
                score += column[i]
                column[i + 1] = 0
                sound.play()  # Play sound when two tiles merge
        shifted_column = [cell for cell in column if cell != 0]
        shifted_column += [0] * (4 - len(shifted_column))
        for i in range(4):
            board[i][j] = shifted_column[i]
    return score

def move_down(board, sound):
    score = 0
    for j in range(4):
        column = [board[i][j] for i in range(4)]
        for i in range(3, 0, -1):
            if column[i] == column[i - 1] and column[i] != 0:
                column[i] *= 2
                score += column[i]
                column[i - 1] = 0
                sound.play()  # Play sound when two tiles merge
        shifted_column = [cell for cell in column if cell != 0]
        shifted_column = [0] * (4 - len(shifted_column)) + shifted_column
        for i in range(4):
            board[i][j] = shifted_column[i]
    return score

def print_board(stdscr, board, score, highest_score):
    stdscr.clear()
    for i in range(4):
        for j in range(4):
            cell = str(board[i][j]).center(4)
            if board[i][j] == 0:
                stdscr.addstr(i * 2, j * 5, cell)
            elif board[i][j] % 2 == 0:
                stdscr.addstr(i * 2, j * 5, cell, curses.color_pair(1))
            else:
                stdscr.addstr(i * 2, j * 5, cell, curses.color_pair(2))
    stdscr.addstr(10, 5, f"Score: {score}")
    stdscr.addstr(11, 5, f"Highest Score: {highest_score}")
    stdscr.refresh()

def game_over(board, score, highest_score):
    for i in range(4):
        for j in range(4):
            if board[i][j] == 2048:
                return True, True  # Game over and won
            if board[i][j] == 0:
                return False, False  # Game not over, not won
            if i < 3 and board[i][j] == board[i + 1][j]:
                return False, False  # Game not over, not won
            if j < 3 and board[i][j] == board[i][j + 1]:
                return False, False  # Game not over, not won
    # Check if the current score is higher than the highest score
    if score > highest_score:
        return True, False  # Game over, not won but highest score updated
    return True, False  # Game over, not won and highest score not updated

def load_user_scores():
    try:
        with open("user_scores.txt", "r") as file:
            user_scores = {}
            for line in file:
                parts = line.split(":")
                if len(parts) == 2:
                    name = parts[0].strip()
                    scores = [int(score) for score in parts[1].split(",")]
                    user_scores[name] = scores
                else:
                    print("Invalid format in line:", line)
    except FileNotFoundError:
        user_scores = {}
    return user_scores


def save_user_scores(user_scores):
    with open("user_scores.txt", "w") as file:
        for name, scores in user_scores.items():
            file.write(f"{name}: {','.join(map(str, scores))}\n")

def get_user_name():
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    user_name = simpledialog.askstring("Input", "Please enter your name:")
    return user_name

def main_menu(stdscr, user_scores):
    stdscr.clear()
    stdscr.addstr(2, 5, "2048 Game", curses.A_BOLD)
    stdscr.addstr(4, 5, "1. Start")
    stdscr.addstr(5, 5, "2. Quit")
    stdscr.addstr(7, 5, "Press 1 or 2 to select an option.")

    stdscr.addstr(9, 5, "Instructions:")
    stdscr.addstr(11, 5, "1. Use arrow keys to move tiles.")
    stdscr.addstr(12, 5, "2. Merge tiles with the same number to increase their value.")
    stdscr.addstr(13, 5, "3. Create a tile with the value of 2048 to win.")
    stdscr.addstr(14, 5, "4. Press 'p' to pause and 'r' to resume the game.")
    stdscr.addstr(15, 5, "5. Press 'q' to quit the game.")

    stdscr.refresh()
    key = stdscr.getch()
    if key == ord('1'):
        user_name = get_user_name()
        if user_name not in user_scores:
            user_scores[user_name] = [0, 0]  # Initialize scores for new user
        play_game(stdscr, user_name, user_scores)
    elif key == ord('2'):
        curses.endwin()
        quit()

def play_game(stdscr, user_name, user_scores):
    sound = init_sound()
    curses.curs_set(0)
    curses.start_color()
    curses.init_pair(1, curses.COLOR_YELLOW, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)

    board = initialize_board()
    add_new_tile(board)
    score = user_scores[user_name][0]
    highest_score = user_scores[user_name][1]
    print_board(stdscr, board, score, highest_score)
    paused = False
    won = False
    while True:
        if not paused:
            key = stdscr.getch()
            if key == ord('q'):
                break
            elif key == ord('p'):
                paused = True
            elif not won:
                if key == curses.KEY_LEFT:
                    score += move_left(board, sound)
                elif key == curses.KEY_RIGHT:
                    score += move_right(board, sound)
                elif key == curses.KEY_UP:
                    score += move_up(board, sound)
                elif key == curses.KEY_DOWN:
                    score += move_down(board, sound)
                else:
                    continue
                add_new_tile(board)
                print_board(stdscr, board, score, highest_score)
                game_over_flag, won = game_over(board, score, highest_score)
                if game_over_flag:
                    if score > highest_score:
                        highest_score = score
                        user_scores[user_name] = [score, highest_score]  # Update user scores
                        save_user_scores(user_scores)
                    stdscr.addstr(12, 5, "Game Over! Press 'm' to main menu")
                    stdscr.refresh()
                    key = stdscr.getch()
                    if key == ord('m'):
                        main_menu(stdscr, user_scores)
                        break
        else:
            stdscr.addstr(10, 5, "Paused. Press 'r' to resume or 'q' to quit.")
            stdscr.refresh()
            key = stdscr.getch()
            if key == ord('r'):
                paused = False
                stdscr.clear()
                print_board(stdscr, board, score, highest_score)
            elif key == ord('q'):
                break

    main_menu(stdscr, user_scores)

def main(stdscr):
    user_scores = load_user_scores()
    while True:
        main_menu(stdscr, user_scores)

if __name__ == "__main__":
    pygame.init()
    curses.wrapper(main)
