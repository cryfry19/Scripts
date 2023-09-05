#!/bin/bash

# Function to extract URLs and their paths from a sitemap.xml file
extract_urls() {
  local sitemap_url="$1"
  local param_only="$2"
  
  # Download the sitemap.xml file
  wget -q -O - "$sitemap_url" | grep -Eo "<loc>[^<]+" | sed 's/<loc>//g' | while read -r url; do
    if [ "$param_only" = "true" ]; then
      # Extract URLs with parameters only
      if [[ "$url" == *"?"* ]]; then
        echo "$url"
      fi
    else
      # Extract entire URLs
      echo "$url"
    fi
  done
}

# Check for command-line arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 <sitemap.xml URL> [options]"
  echo "Options:"
  echo "  -p   Extract URLs with parameters only"
  exit 1
fi

sitemap_url="$1"
param_only="false"

# Check for the -p option
if [ "$2" = "-p" ]; then
  param_only="true"
fi

# Call the extract_urls function with the provided arguments
extract_urls "$sitemap_url" "$param_only"
