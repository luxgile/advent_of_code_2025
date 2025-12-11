inputs = []
with open("day1.txt", "r") as input_file:
    lines = input_file.readlines()
    for line in lines:
        rotation = int(line[1:])
        if line[0] == "L":
            rotation *= -1
        inputs.append(rotation)

part1_result = 0
dial = 50
for input in inputs:
    dial += input
    dial %= 100
    if dial == 0:
        part1_result += 1


print("part 1: ", part1_result)
