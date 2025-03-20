def threeSumClosest(nums, target):
    nums.sort()  # Sort the array first
    closest_sum = float('inf')  # Initialize with a large value

    for i in range(len(nums) - 2):  # Iterate through each number
        left, right = i + 1, len(nums) - 1  # Two pointers

        while left < right:
            current_sum = nums[i] + nums[left] + nums[right]

            # Update the closest sum if the current sum is closer to target
            if abs(target - current_sum) < abs(target - closest_sum):
                closest_sum = current_sum

            # Move pointers based on sum comparison
            if current_sum < target:
                left += 1  # Increase left pointer to get a larger sum
            elif current_sum > target:
                right -= 1  # Decrease right pointer to get a smaller sum
            else:
                return current_sum  # Exact match found

    return closest_sum  # Return the closest sum found

# Example usage
nums = [-1, 2, 1, -4]
target = 1
print(threeSumClosest(nums, target))  # Output: 2