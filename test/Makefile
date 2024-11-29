# Compiler
CC = gcc

# Target executable name
TARGET = test

# Default rule to build the target
all: $(TARGET)

# Rule to build the executable
$(TARGET): test.c
	$(CC) -o $(TARGET) test.c

# Clean up generated files
clean:
	rm -f $(TARGET)
