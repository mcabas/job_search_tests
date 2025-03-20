def FizzBuzz(n):
    for e in range(1, n + 1):  # Iterate from 1 to n (inclusive)
        if e % 3 == 0 and e % 5 == 0:
            print("FizzBuzz")
        elif e % 3 == 0:
            print("Fizz")
        elif e % 5 == 0:
            print("Buzz")
        else:
            print(e)

# Example usage
FizzBuzz(15)