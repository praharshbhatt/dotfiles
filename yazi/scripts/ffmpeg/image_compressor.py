
import os
import sys
import logging
import argparse
from PIL import Image

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def compress_image(input_file, output_file, quality=85):
    """
    Compresses the input image file and saves it to the output file path.
    The compression maintains the original image resolution and format.
    """
    try:
        # Open the image file
        with Image.open(input_file) as img:
            # Preserve original image format
            format = img.format

            # Save the compressed image
            img.save(output_file, format=format, optimize=True, quality=quality)

        # Preserve timestamps
        stat_info = os.stat(input_file)
        os.utime(output_file, (stat_info.st_atime, stat_info.st_mtime))

        logging.info(f"Successfully compressed {input_file} to {output_file}")

    except Exception as e:
        logging.error(f"Error compressing {input_file}: {e}")
        return False
    return True

def process_image(input_image_file, quality=85):
    """
    Compresses a single image file.
    If the input and output paths are the same, the original file is overwritten.
    """
    # Check if the input file exists
    if not os.path.isfile(input_image_file):
        logging.error(f"Input file {input_image_file} does not exist.")
        sys.exit(1)

    # Handle permission errors or issues with the input file
    if not os.access(input_image_file, os.R_OK):
        logging.error(f"Cannot read file: {input_image_file}")
        sys.exit(1)

    # Define output file (same location, overwrite original)
    output_file = input_image_file

    # Compress the image
    success = compress_image(input_image_file, output_file, quality=quality)
    if success:
        logging.info(f"Image compression completed: {output_file}")
    else:
        logging.error(f"Image compression failed: {input_image_file}")

def main():
    # Argument parser setup
    parser = argparse.ArgumentParser(description="Compress a single image file without loss of resolution.")
    parser.add_argument("input_image_file", help="Path to the image file to be compressed")
    parser.add_argument("--quality", type=int, default=85, help="Compression quality (default: 85)")

    args = parser.parse_args()

    input_image_file = args.input_image_file

    # Process the single image file
    process_image(input_image_file, args.quality)

if __name__ == "__main__":
    main()
