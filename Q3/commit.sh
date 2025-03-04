#!/bin/bash

# Define repository path as the current directory
REPO_PATH="."

# Define file paths
EXCEL_FILE="$REPO_PATH/data.xlsx"
LOG_FILE="$REPO_PATH/error.log"
COMMITS_FILE="$REPO_PATH/commits.txt"

# Check if the Excel file exists
if [ ! -f "$EXCEL_FILE" ]; then
    echo "Error: Excel file not found!" | tee -a "$LOG_FILE"
    exit 1
fi

# Save commit history to a file
git log --oneline > "$COMMITS_FILE"

# Check if there are changes to commit
if git status | grep -q "nothing to commit"; then
    echo "No new changes to commit."
else
    git add .
    git commit -m "Automated commit with script" || echo "Error: Commit failed!" >> "$LOG_FILE"
    git push origin main 2>> "$LOG_FILE"
fi

echo "Commit script executed successfully."
