inputs = []
with open("day1.txt", "r") as input_file:
    lines = input_file.readlines()
    for line in lines:
        rotation = int(line[1:])
        if line[0] == "L":
            rotation *= -1
        inputs.append(rotation)

part2_result = 0
dial = 50
for input in inputs:
    prev_dial = dial
    dial += input
    if dial > 99:
        part2_result += int(dial / 100)
    if dial <= 0:
        part2_result += int(-dial / 100)
        if prev_dial != 0:  # To account when the dial is already at 0
            part2_result += 1

    dial %= 100


print("part 2: ", part2_result)
