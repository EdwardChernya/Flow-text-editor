import os
import sys
import subprocess

# Ensure UTF-8 encoding
os.environ["PYTHONIOENCODING"] = "utf-8"

# Check if we have the correct number of arguments
if len(sys.argv) < 4:
    print("Usage: python download.py <url> <file_name> <directory>")
    sys.exit(1)

# Collect the URL and file name passed from the batch file
url = sys.argv[1]  # The URL passed
file_name = sys.argv[2]  # The file name without extension
save_directory = sys.argv[3]  # Directory where you want the file and output.txt to be saved

# Add the .mp3 extension to the output file if not present
output_file = file_name + ".mp3"

# Ensure the save directory exists
if not os.path.exists(save_directory):
    print(f"Directory {save_directory} does not exist. Creating it now...")
    os.makedirs(save_directory)

# Construct the command to run (with URL and output file as arguments)
command = [
    "python", 
    "-m", 
    "ytube_api", 
    "download", 
    url, 
    "--mp3", 
    "--output", 
    output_file,
    "--dir", 
    save_directory  # Tell ytube_api to save the content in the specified directory
]

# Prepare the output file path for the logs (adding .txt extension)
output_file_path = os.path.join(save_directory, file_name + ".txt")

# Ensure the output file path is valid (this is just a precaution)
if not os.path.isdir(save_directory):
    print(f"Error: {save_directory} is not a valid directory.")
    sys.exit(1)

# Run the process and capture the output in real-time
with open(output_file_path, "w", encoding="utf-8") as f:
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)

    for line in process.stdout:
        print(line, end="")  # Print live output
        f.write(line)  # Save to file

    process.wait()  # Ensure the process completes

# Print any final message or status after the process finishes (optional)
print("\ndownload.py completed. Check the output for details.")
