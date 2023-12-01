from typing import List

mapping = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
}


def get_input() -> List[str]:
    with open('input.txt') as inp:
        return inp.read().splitlines(False)


def text_to_digit(line: str) -> str:
    current = line
    for key, value in mapping.items():
        current = current.replace(key, key + value + key)
    return current


def main():
    data = [text_to_digit(line) for line in get_input()]
    digits = [[c for c in line if c.isdigit()] for line in data]
    first_and_last = [digit[0] + digit[-1] for digit in digits]
    total = sum(map(int, first_and_last))
    print(total)


if __name__ == '__main__':
    main()
