#!/bin/bash

CSV_FILE="data.csv"
OUTPUT_FILE="5_output.txt"

# Function to display CSV file with row index
display_csv() {
    echo "CSV Data with Row Index:"
    awk 'NR==1{print "Index, "$0} NR>1{print NR-1","$0}' "$CSV_FILE"
}

# Function to add a new row
add_row() {
    echo "Enter Date collected (MM/DD):"
    read date
    echo "Enter Species:"
    read species
    echo "Enter Sex (M/F):"
    read sex
    echo "Enter Weight:"
    read weight
    echo "$date,$species,$sex,$weight" >> "$CSV_FILE"
    echo "Row added successfully!"
}

# Function to filter by species and calculate AVG weight
filter_species() {
    echo "Enter species to filter (e.g., OT, PF, NA):"
    read species
    echo "Filtered Data:"
    awk -F, -v sp="$species" '$2 == sp {sum+=$4; count++} count>0{print $0} END{if(count>0) print "Average Weight:", sum/count}' "$CSV_FILE"
}

# Function to filter by sex
filter_sex() {
    echo "Enter sex to filter (M/F):"
    read sex
    echo "Filtered Data:"
    awk -F, -v sx="$sex" '$3 == sx {print $0}' "$CSV_FILE"
}

# Function to delete a row by index
delete_row() {
    echo "Enter row index to delete:"
    read index
    sed -i "${index}d" "$CSV_FILE"
    echo "Row deleted successfully!"
}

# Function to update weight by row index
update_weight() {
    echo "Enter row index to update weight:"
    read index
    echo "Enter new weight:"
    read weight
    awk -F, -v idx="$index" -v new_weight="$weight" 'NR==idx+1{$4=new_weight}1' OFS=, "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "Weight updated successfully!"
}

# Function to save output to new CSV
save_output() {
    echo "Saving last output to $OUTPUT_FILE..."
    display_csv > "$OUTPUT_FILE"
    echo "Saved successfully!"
}

# Menu loop
while true; do
    echo -e "\n--- CSV Manager Menu ---"
    echo "1. Display CSV with Row Index"
    echo "2. Add a New Row"
    echo "3. Filter by Species & AVG Weight"
    echo "4. Filter by Sex"
    echo "5. Delete Row by Index"
    echo "6. Update Weight by Index"
    echo "7. Save Output to New CSV"
    echo "8. Exit"
    read -p "Choose an option: " option

    case $option in
        1) display_csv ;;
        2) add_row ;;
        3) filter_species ;;
        4) filter_sex ;;
        5) delete_row ;;
        6) update_weight ;;
        7) save_output ;;
        8) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
