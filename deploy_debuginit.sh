#!/bin/sh
# Deployment script for debuginit-object-storage Rust binary

BINARY_PATH="./debuginit-object-storage-x86_64-unknown-linux-musl"
LOG_FILE="./debuginit-object-storage.log"
PID_FILE="./debuginit-object-storage.pid"
PORT_FILE="./debuginit-object-storage.port"

# Specify the port for this service
PORT=21000  # Change this port as required

# Check if the port is already in use
if ss -tuln | grep -q ":$PORT\b"; then
    echo "Port $PORT is already in use. Please choose a different port."
    exit 1
fi

# Stop any previous instance of this binary (if running)
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "Stopping previous instance (PID $OLD_PID)"
        kill $OLD_PID
        sleep 2
    fi
    rm -f "$PID_FILE"
    rm -f "$PORT_FILE"
fi

echo "Starting debuginit-object-storage on port $PORT"
nohup "$BINARY_PATH" --port $PORT > "$LOG_FILE" 2>&1 &

# Save PID and port for management
echo $! > "$PID_FILE"
echo $PORT > "$PORT_FILE"

echo "Deployment started on port $PORT. Logs: $LOG_FILE"
sleep 2
if ps -p $(cat "$PID_FILE") > /dev/null 2>&1; then
    echo "Process started successfully with PID $(cat "$PID_FILE")"
else
    echo "Process failed to start. Check $LOG_FILE"
fi
