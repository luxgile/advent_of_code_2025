def get_pair_from_index(line: str, index: int):
    first = line[index]
    max = 0
    for c in line[index + 1 :]:
        n = int(first + c)
        if n > max:
            max = n
    return max


def get_biggest_pair(line: str):
    length = len(line) - 1
    max = 0
    for i in range(length):
        n = get_pair_from_index(line, i)
        if n > max:
            max = n
    return max


with open("input/day3.txt", "r") as input:
    result = 0
    for line in input:
        result += get_biggest_pair(line)
    print(f"day 3: {result}")
