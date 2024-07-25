import re
import os
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

def process_file(input_file):
    with open(input_file, 'r') as file:
        content = file.read()
    
    # Extract all time strings
    time_strings = re.findall(r'Elapsed \(wall clock\) time \(h:mm:ss or m:ss\): ([0-9]+:[0-9]{2}\.[0-9]{2})', content)
    
    # Convert time strings to timedelta objects
    times = [parse_time(time_str) for time_str in time_strings]
    
    # Calculate the average of every three times
    averages = [average_time(times[i:i+3]) for i in range(0, len(times), 3) if len(times[i:i+3]) == 3]
    
    # Prepare output directory and file path
    output_dir = "./averagetime"
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, os.path.basename(input_file))
    
    # Write the results to the output file
    with open(output_file, 'w') as file:
        for avg in averages:
            file.write(f"Average time: {str(avg)}\n")

def process_directory(directory_path):
    """遍历目录并对每个文件进行操作"""
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            process_file(file_path)

if __name__ == "__main__":
    directory_path = "./testoutcome/three_times"  # 目标目录路径
    process_directory(directory_path)