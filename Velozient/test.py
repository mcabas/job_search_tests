import requests

def best_university_by_country(country: str) -> str:
    base_url = "https://jsonmock.hackerrank.com/api/universities"
    page = 1
    best_university = ""
    best_rank = float('inf')  # Set initial rank to a very large number

    while True:
        response = requests.get(f"{base_url}?page={page}")
        if response.status_code != 200:
            return ""  # API error handling
        
        data = response.json()
        universities = data.get("data", [])

        for uni in universities:
            if uni.get("location", {}).get("country") == country:
                rank_display = uni.get("rank_display", "")
                
                # Convert rank to an integer for proper sorting
                try:
                    rank = int(rank_display)
                except ValueError:
                    continue  # Skip if rank is not a number
                
                if rank < best_rank:
                    best_rank = rank
                    best_university = uni.get("university", "")

        if page >= data.get("total_pages", 1):
            break  # Stop when we've checked all pages
        page += 1  # Move to the next page

    return best_university  # Return the best university or an empty string

# Example Usage:
print(best_university_by_country("India"))  # Expected Output: "Indian Institute of Technology Bombay"
print(best_university_by_country("United Kingdom"))  # Expected Output: "University of Oxford"
print(best_university_by_country("Nonexistent Country"))  # Expected Output: ""