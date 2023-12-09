import math
from itertools import chain, repeat
from pprint import pprint
from typing import Dict, Tuple, List
import numpy


def solve_part1(directions: List[Tuple[int, str]], mapping: Dict[str, Tuple[str, str]], start: str = 'AAA', end: str = 'ZZZ'):
    current_location: str = start
    for idx, (direction_idx, current_direction) in enumerate(chain.from_iterable(repeat(directions))):
        current_mapping = mapping[current_location]
        next_location = current_mapping[0 if current_direction == 'L' else 1]
        # print(f"{current_location} -> {current_mapping} {current_direction} -> {next_location} @{idx}")
        current_location = next_location
        if current_location.endswith(end):
            print(f"Took step +{idx + 1:09} to {next_location}")
            return idx + 1


def solve_part2(directions: List[Tuple[int, str]], mapping: Dict[str, Tuple[str, str]]):
    current_positions = [key for key in mapping.keys() if key.endswith('A')]
    iterations_to_solve = {pos: solve_part1(directions, mapping, pos, 'Z') for pos in current_positions}
    pprint(iterations_to_solve)
    print(f"lcm: {math.lcm(*iterations_to_solve.values())}")

    #
    # for idx, (direction_idx, current_direction) in enumerate(chain.from_iterable(repeat(directions))):
    #     next_positions = [
    #         current_mapping[0 if current_direction == 'L' else 1]
    #         for current_mapping
    #         in [v for k, v in mapping.items() if k in current_positions]
    #     ]
    #     current_positions = next_positions
    #     if idx % 10000 == 0:
    #         print(f"Took step {current_direction} +{idx + 1:09} to {', '.join(next_positions)}")
    #     if all(pos.endswith('Z') for pos in next_positions):
    #         print(f"Took step {current_direction} +{idx + 1:09} to {', '.join(next_positions)}")
    #         break


def main():
    with open('input.txt') as f:
    # with open('sample3.txt') as f:
        first_line = next(f).strip()
        first_line_l = list(enumerate(first_line))

        mapping = {}

        for line in f:
            stripped = line.strip()
            if not stripped:
                continue
            pre, post = stripped.split('=')
            location = pre.strip()
            left, right = [x.strip(' ()') for x in post.split(',')]
            mapping[location] = (left, right)

    # print([mapping.keys()])
        # solve_part1(first_line_l, mapping)
    solve_part2(first_line_l, mapping)


if __name__ == '__main__':
    main()
