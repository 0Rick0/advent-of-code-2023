
# MODE = 'part1'
MODE = 'part2'


def rows_to_columns(rows: list[str]) -> list[str]:
    columns = []
    for i in range(len(rows[0])):
        columns.append(''.join(row[i] for row in rows))
    return columns


def find_duplicates(rows: list[str]) -> list[int]:
    result = []
    for i, (item, next_item) in enumerate(zip(rows, rows[1:])):
        if item == next_item:
            result.append(i)
    return result


def count_errors(a: str, b: str) -> int:
    errors = 0
    for ac, bc in zip(a, b):
        if ac != bc:
            errors += 1
    return errors


def find_off_by_one(rows: list[str]) -> list[int]:
    result = []
    for i, (item, next_item) in enumerate(zip(rows, rows[1:])):
        if count_errors(item, next_item) <= 1:
            result.append(i)
    return result


def is_mirror(buffer: list[str], offset: int) -> bool:
    strict = True if MODE == 'part1' else False
    for i, j in zip(range(offset, -1, -1), range(offset + 1, len(buffer))):
        if strict:
            if buffer[i] != buffer[j]:
                return False
        else:
            errors = count_errors(buffer[i], buffer[j])
            if errors == 0:
                continue
            elif errors == 1:
                strict = True
                continue
            else:
                return False
    return True


def process_buffer(rows: list[str]) -> int:
    columns = rows_to_columns(rows)
    if MODE == 'part1':
        duplicate_columns = find_duplicates(columns)
        duplicate_rows = find_duplicates(rows)
    else:
        duplicate_columns = find_off_by_one(columns)
        duplicate_rows = find_off_by_one(rows)

    for row in duplicate_rows:
        if is_mirror(rows, row):
            return (row + 1) * 100

    for column in duplicate_columns:
        if is_mirror(columns, column):
            return column + 1

    raise ValueError('No reflection')


def main(input_file: str):
    buffer = []
    result = 0
    with open(input_file) as f:
        for line in f.readlines():
            if len(line.strip()) == 0:
                result += process_buffer(buffer)
                buffer.clear()
            else:
                buffer.append(line.strip())
        result += process_buffer(buffer)

    print(result)


if __name__ == '__main__':
    assert is_mirror(['a', 'b', 'b', 'a'], 1)
    assert is_mirror(['b', 'b', 'a'], 0)
    assert is_mirror(['a', 'b', 'b'], 1)
    assert is_mirror(
        [
            "#.##..##.",
            "..#.##.#.",
            "##......#",
            "##......#",
            "..#.##.#.",
            "..##..##.",
            "#.#.##.#.",
        ],
        2) == (MODE == 'part2')
    assert is_mirror(
        [
            "#.##..##.",
            "..#.##.#.",
            "##..#...#",
            "##...#..#",
            "..#.##.#.",
            "..##..##.",
            "#.#.##.#.",
        ],
        2) == (MODE == 'part2')
    main('sampleinput2.txt')
