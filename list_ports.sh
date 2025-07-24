#!/bin/sh
# List all used ports with associated process and PID

echo "Listing all ports currently in use:"
echo "-----------------------------------"
# Show TCP and UDP ports with process info
if command -v ss > /dev/null 2>&1; then
    # ss is preferred
    ss -tulpen
else
    # Fallback to netstat if ss is not available
    netstat -tulpen
fi

echo
echo "Summary of ports and associated processes:"
echo "------------------------------------------"
# Summarized output: port, PID, and program name
if command -v ss > /dev/null 2>&1; then
    ss -tulpen | awk 'NR>1 {print $5, $6, $7}' | sort | uniq
else
    netstat -tulpen | awk 'NR>2 {print $4, $7, $8}' | sort | uniq
fi
