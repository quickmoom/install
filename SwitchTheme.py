import os
import json
import subprocess

# Change the working directory to .config/scripts
os.chdir(os.path.expanduser('~/.config/scripts'))

#######################
# Switch Current File #
#######################

# Specify the wallpapers directory
directory = os.path.expanduser('~/.config/wallpapers')

# Create a directory for saving PNG files
png_directory = os.path.join(directory, 'png')
os.makedirs(png_directory, exist_ok=True)

# Define the theme directory
theme_directory = os.path.expanduser('~/.cache/wal/schemes')

# Define the Hyprland theme configuration path
hypr_theme_conf_path = os.path.expanduser('~/.config/hypr/theme.conf')

# Get a list of files in the directory, excluding directories
files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

# Read the last saved file index, if it exists
index_file = 'index.txt'
if os.path.exists(index_file):
    with open(index_file, 'r') as f:
        last_index = int(f.read().strip())
else:
    last_index = -1

# Determine the next file index in a cyclic manner
next_index = (last_index + 1) % len(files)

# Write the next file to current.txt
with open('current.txt', 'w') as output_file:
    output_file.write(files[next_index] + '\n')

# Save the current index for the next run
with open(index_file, 'w') as f:
    f.write(str(next_index))

####################
# Search Theme Directory #
####################

# Get the current file name without extension
current_file_base = os.path.splitext(files[next_index])[0]

# Search for JSON files in theme_directory containing the current file name
matching_files = [f for f in os.listdir(theme_directory) if current_file_base in f and f.endswith('.json')]

if matching_files:
    matching_file = os.path.join(theme_directory, matching_files[0])
    print(f"DEBUG: Matching theme file found: {matching_file}")

    # Load the JSON file and extract colors 3 and 13
    with open(matching_file, 'r') as json_file:
        theme_data = json.load(json_file)
        # Remove the `#` from the color values
        color3 = theme_data['colors']['color3'].replace('#', '')
        color13 = theme_data['colors']['color13'].replace('#', '')
        print(f"DEBUG: color3: {color3}, color13: {color13}")
else:
    print(f"DEBUG: No matching theme files found for: {current_file_base}")
    color3 = "FFFFFF"  # Default to white if no theme is found
    color13 = "000000"  # Default to black if no theme is found

####################
# Write Hyprland Theme Config #
####################

# Define the content of the theme configuration with the content you pasted
theme_config_content = f"""
general {{ 
    gaps_in = 3
    gaps_out = 2

    border_size = 5

    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col.active_border = rgba({color3}ee) rgba({color13}ee) 45deg
    col.inactive_border = rgba(595959aa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false 

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    layout = dwindle
}}
"""

# Write the theme configuration to theme.conf
with open(hypr_theme_conf_path, 'w') as theme_conf_file:
    theme_conf_file.write(theme_config_content)

print(f"DEBUG: Hyprland theme configuration written to {hypr_theme_conf_path}")

################
# RUN COMMANDS #
################

# Get the current file
current_file = files[next_index]

# Determine full path (ensure separator)
full_path = os.path.join(directory, current_file)

# Function to run a command in the background
def run_command_in_background(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return process

# First, kill any existing mpvpaper processes
kill_command = 'pkill mpvpaper'
subprocess.run(kill_command, shell=True)

# Command to run mpvpaper with the current file
command = f'mpvpaper -o "no-audio loop" "*" {full_path}'

# Run the command in the background
process = run_command_in_background(command)

####################
# Capture Frame as PNG #
####################

# Path to save the PNG file
png_path = os.path.join(png_directory, f'{os.path.splitext(current_file)[0]}.png')

# Check if the PNG file already exists
if not os.path.exists(png_path):
    # Command to capture a frame from the video
    capture_command = f'ffmpeg -i "{full_path}" -ss 00:00:00 -vframes 1 "{png_path}"'
    
    # Run the frame capture command
    subprocess.run(capture_command, shell=True)
else:
    print(f"DEBUG: File already exists: {png_path}")

####################
# Apply Wallpaper #
####################

# Command to run wal with the PNG file
wal_command = f'wal -i "{png_path}"'

# Run the wal command
subprocess.run(wal_command, shell=True)

#########
# DEBUG #
#########

# Print the debug information
print(f"DEBUG: CURRENT FILE: {current_file}")
print(f"DEBUG: Command: {command}")

# Optionally, print stdout and stderr from the background process if needed
stdout, stderr = process.communicate()
print(f"DEBUG: Command Output:\n{stdout}")
print(f"DEBUG: Command Error:\n{stderr}")
