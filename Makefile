# Makefile for USearch demo programs
# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -O2
INCLUDES = -I./usearch/include

# Optional include directories (if fp16 and simsimd are present)
# Uncomment if needed:
# INCLUDES += -I./usearch/fp16/include
# INCLUDES += -I./usearch/simsimd/include

# Libraries
LDFLAGS = -pthread

# macOS specific flags
ifeq ($(shell uname), Darwin)
    LDFLAGS += -framework CoreFoundation -framework Security
endif

# USearch repository configuration
USEARCH_REPO_URL = https://github.com/unum-cloud/usearch.git
USEARCH_DIR = usearch
USEARCH_INCLUDE_DIR = $(USEARCH_DIR)/include

# Source files
CREATE_INDEX_SRC = create_index.cpp
SEARCH_INDEX_SRC = search_index.cpp

# Object files
CREATE_INDEX_OBJ = $(CREATE_INDEX_SRC:.cpp=.o)
SEARCH_INDEX_OBJ = $(SEARCH_INDEX_SRC:.cpp=.o)

# Executables
CREATE_INDEX_EXE = create_index
SEARCH_INDEX_EXE = search_index

# Default target
all: $(CREATE_INDEX_EXE) $(SEARCH_INDEX_EXE)

# Clone usearch repository if it doesn't exist
$(USEARCH_DIR):
	@echo "Cloning USearch repository..."
	git clone $(USEARCH_REPO_URL) $(USEARCH_DIR)
	@echo "USearch repository cloned successfully."

# Ensure usearch/include exists before building
$(USEARCH_INCLUDE_DIR): $(USEARCH_DIR)

# Build create_index executable
$(CREATE_INDEX_EXE): $(CREATE_INDEX_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)

# Build search_index executable
$(SEARCH_INDEX_EXE): $(SEARCH_INDEX_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)

# Compile create_index.cpp to object file
$(CREATE_INDEX_OBJ): $(CREATE_INDEX_SRC) $(USEARCH_INCLUDE_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile search_index.cpp to object file
$(SEARCH_INDEX_OBJ): $(SEARCH_INDEX_SRC) $(USEARCH_INCLUDE_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Clone usearch repository explicitly
clone-usearch: $(USEARCH_DIR)

# Clean build artifacts
clean:
	rm -f $(CREATE_INDEX_OBJ) $(SEARCH_INDEX_OBJ) $(CREATE_INDEX_EXE) $(SEARCH_INDEX_EXE)

# Clean everything including usearch directory
clean-all: clean
	@if [ -d "$(USEARCH_DIR)" ]; then \
		echo "Removing $(USEARCH_DIR) directory..."; \
		chmod -R u+w $(USEARCH_DIR) 2>/dev/null || true; \
		rm -rf $(USEARCH_DIR) 2>/dev/null || true; \
	fi

# Phony targets
.PHONY: all clean clean-all clone-usearch

