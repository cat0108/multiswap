import re
from datetime import datetime, timedelta

def parse_time(time_str):
    """Parse time string in h:mm:ss or m:ss format to timedelta."""
    try:
        # Handle h:mm:ss
        return datetime.strptime(time_str, "%H:%M:%S") - datetime(1900, 1, 1)
    except ValueError:
        # Handle m:ss
        return datetime.strptime(time_str, "%M:%S.%f") - datetime(1900, 1, 1)

def average_time(times):
    """Calculate the average of a list of timedelta objects."""
    total = sum(times, timedelta())
    return total / len(times)

def main(input_file):
    with open(input_file, 'r') as file:
        content = file.read()
    
    # Extract all time strings
    time_strings = re.findall(r'Elapsed \(wall clock\) time \(h:mm:ss or m:ss\): ([0-9]+:[0-9]{2}\.[0-9]{2})', content)
    
    # Convert time strings to timedelta objects
    times = [parse_time(time_str) for time_str in time_strings]
    
    # Calculate the average of every three times
    averages = [average_time(times[i:i+3]) for i in range(0, len(times), 3) if len(times[i:i+3]) == 3]
    
    # Output the results
    for avg in averages:
        print(f"Average time: {str(avg)}")

if __name__ == "__main__":
    input_file = "./testoutcome/linpack_dram_result.txt"  # Replace with your input file name
    main(input_file)