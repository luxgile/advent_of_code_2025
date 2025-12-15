def optimise_bank(bank: list[int], n_left: int):
    if n_left != 1:
        n_left -= 1
        first = max(bank[:-n_left])
        where = bank.index(first)
        first *= 10**n_left
        return first + optimise_bank(bank[where + 1 :], n_left)
    else:
        return max(bank)


with open("input/day3.txt", "r") as input:
    result = 0
    for line in input:
        numbers = [int(n) for n in line.strip()]
        result += optimise_bank(numbers, 12)
    print(f"day 3b: {result}")
