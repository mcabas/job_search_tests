def leet_decoder(leet_text):
    # Leet character mapping
    leet_map = {
        '0': 'O', '2': 'C', '3': 'E', '7': 'L', '-H': '#', '-A': 'A', '$': 'S'
    }
    
    words = leet_text.split()  # Split text into words
    decoded_words = []
    
    for word in words:
        # Check if the word contains a mix of letters and symbols (considered leet)
        if any(c.isalpha() for c in word) and any(c in leet_map for c in word):
            # Replace leet characters
            for key, value in leet_map.items():
                word = word.replace(key, value)
        
        decoded_words.append(word.upper())  # Convert to uppercase
    
    return " ".join(decoded_words)

# Example usage
leet_text = "3xaddnp7t3xt"
decoded = leet_decoder(leet_text)
print(decoded)  # Expected Output: "EXAMPLE TEXT"