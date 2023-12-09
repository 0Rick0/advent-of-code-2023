from itertools import chain, repeat
from pprint import pprint

def main():
    with open('input.txt') as f:
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
        
        # pprint(mapping)

        # print(first_line)

        current_location = 'AAA'
        for idx, (direction_idx, current_direction) in enumerate(chain.from_iterable(repeat(first_line_l))):
            current_mapping = mapping[current_location]
            next_location = current_mapping[0 if current_direction == 'L' else 1]
            # print(f"{current_location} -> {current_mapping} {current_direction} -> {next_location} @{idx}")
            print(f"Took step +{idx+1:09} to {next_location}")
            current_location = next_location
            if current_location == 'ZZZ':
                break

if __name__ == '__main__':
    main()