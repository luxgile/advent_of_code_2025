def is_invalid_id(id):
    id_str = str(id)
    if len(id_str) % 2 != 0:
        return False
    midpoint = len(id_str) // 2
    return id_str[0:midpoint] == id_str[midpoint:]


ranges = []
with open("day2.txt", "r") as input_file:
    low, high = 0, 0
    on_low = True
    number = ""
    for range_str in input_file.readlines()[0].split(","):
        split = range_str.split("-")
        ranges.append(range(int(split[0]), int(split[1]) + 1))

part1_solution = 0
for r in ranges:
    for n in r:
        if is_invalid_id(n):
            print(n)
            part1_solution += n

print(part1_solution)
