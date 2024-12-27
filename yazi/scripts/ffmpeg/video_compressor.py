
import os
import subprocess
import argparse
import logging
import sys

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def generate_unique_filename(file_path):
    """
    Generates a unique filename by appending a number (_1, _2, etc.) to the base name if the file already exists.
    """
    base, ext = os.path.splitext(file_path)
    counter = 1
    new_file_path = f"{base}_{counter}{ext}"
    
    while os.path.exists(new_file_path):
        counter += 1
        new_file_path = f"{base}_{counter}{ext}"
    
    return new_file_path

def convert_video(input_file, output_file):
    """
    Converts the input video file to a more efficient MP4 file without dropping resolution, frame rate, or audio quality.
    Preserves the original file's timestamps.
    """
    try:
        # ffmpeg command to convert video
        command = [
            'ffmpeg',
            '-i', input_file,             # Input file
            '-vcodec', 'libx264',          # Video codec: H.264
            '-acodec', 'aac',              # Audio codec: AAC
            '-b:v', '1M',                  # Bitrate (adjust as needed for more/less compression)
            '-strict', 'experimental',     # Ensures compatibility with some formats
            '-preset', 'slow',             # Preset for better compression (can use 'medium', 'fast' etc. based on speed/quality trade-off)
            '-crf', '23',                  # Constant Rate Factor: lower means better quality (default 23)
            '-y',                          # Overwrite output file without asking
            output_file                    # Output file
        ]

        logging.info(f"Converting {input_file} to {output_file}")
        # Run the ffmpeg command
        subprocess.run(command, check=True)

        # Preserve timestamps
        stat_info = os.stat(input_file)
        os.utime(output_file, (stat_info.st_atime, stat_info.st_mtime))  # Set access and modification times

        logging.info(f"Successfully converted and preserved timestamps for: {input_file}")
    except subprocess.CalledProcessError as e:
        logging.error(f"Error converting {input_file}: {e}")
        return False
    except Exception as e:
        logging.error(f"Unexpected error occurred with {input_file}: {e}")
        return False
    return True

def process_video(input_video_file):
    """
    Processes a single video file for conversion and saves it as a new file with a unique name if the file already exists.
    """
    # Check if the input file exists
    if not os.path.isfile(input_video_file):
        logging.error(f"Input file {input_video_file} does not exist.")
        sys.exit(1)

    # Handle permission errors or issues with the input file
    if not os.access(input_video_file, os.R_OK):
        logging.error(f"Cannot read file: {input_video_file}")
        sys.exit(1)

    # Generate a unique output file name if the file already exists
    output_file = generate_unique_filename(input_video_file)

    # Convert the video
    success = convert_video(input_video_file, output_file)
    if success:
        logging.info(f"Video conversion completed: {output_file}")
    else:
        logging.error(f"Video conversion failed for: {input_video_file}")

def main():
    # Argument parser setup
    parser = argparse.ArgumentParser(description="Compress a single video file without loss of resolution or frame rate.")
    parser.add_argument("input_video_file", help="Path to the video file to be converted")

    args = parser.parse_args()

    # Process the single video file
    process_video(args.input_video_file)

if __name__ == "__main__":
    main()
