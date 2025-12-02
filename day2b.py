def div_gen(n):
    for i in range(1, n):
        if n % i == 0:
            yield i


def is_invalid_id(id):
    id_str = str(id)
    length = len(id_str)
    for div in div_gen(length):
        r = id_str.count(id_str[0:div]) == (length // div)
        if r:
            return True
    return False


ranges = []
with open("day2.txt", "r") as input_file:
    low, high = 0, 0
    on_low = True
    number = ""
    for range_str in input_file.readlines()[0].split(","):
        split = range_str.split("-")
        ranges.append(range(int(split[0]), int(split[1]) + 1))

part2_solution = 0
for r in ranges:
    for n in r:
        if is_invalid_id(n):
            part2_solution += n

print(part2_solution)
