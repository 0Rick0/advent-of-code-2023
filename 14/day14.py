#!/usr/bin/env python3
from typing import TextIO


def parse_input(inp: TextIO) -> list[list[str]]:
    return [[c for c in line.strip()] for line in inp.readlines()]


def swap(board: list[list[str]], x1: int, y1: int, x2: int, y2: int):
    board[y1][x1], board[y2][x2] = board[y2][x2], board[y1][x1]


def move_north(board: list[list[str]], x: int, y: int):
    if y == 0:
        return
    if board[y - 1][x] == "#":
        return # can't move up
    if board[y - 1][x] == '.':
        swap(board, x, y, x, y - 1)
        move_north(board, x, y - 1)


def tilt_north(board: list[list[str]]):
    for y in range(len(board)):
        for x in range(len(board[0])):
            if board[y][x] == 'O':
                move_north(board, x, y)


def score_board(board: list[list[str]]) -> int:
    board_len = len(board)
    total = 0
    for i, line in enumerate(board):
        total += line.count('O') * (board_len - i)
    return total


def main():
    with open('sampleinput.txt') as f:
        sample_board = parse_input(f)
        tilt_north(sample_board)
        print('\n'.join(''.join(line) for line in sample_board))
        sample_score = score_board(sample_board)
        print(sample_score)
        assert sample_score == 136, 'Different score'
    with open('input.txt') as f:
        board = parse_input(f)
        tilt_north(board)
        score = score_board(board)
        print(score)


if __name__ == '__main__':
    main()
