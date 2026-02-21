.PHONY: all build install uninstall clean help test

# Build variables
BINARY_NAME=picoclaw
BUILD_DIR=build
CMD_DIR=cmd\$(BINARY_NAME)
MAIN_GO=$(CMD_DIR)\main.go

# Version
VERSION?=dev
GIT_COMMIT=dev
BUILD_TIME=$(shell powershell -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'")
GO_VERSION?=$(shell go version 2>NUL | findstr go)

LDFLAGS=-ldflags="-X main.version=$(VERSION) -X main.gitCommit=$(GIT_COMMIT) -X main.buildTime=$(BUILD_TIME) -X main.goVersion=$(GO_VERSION)"

# Go variables
GO?=go
GOFLAGS?=-v

# Installation
INSTALL_PREFIX?=$(USERPROFILE)\.local
INSTALL_BIN_DIR=$(INSTALL_PREFIX)\bin
INSTALL_MAN_DIR=$(INSTALL_PREFIX)\share\man\man1

# Workspace and Skills
PICOCLAW_HOME?=$(USERPROFILE)\.picoclaw
WORKSPACE_DIR?=$(PICOCLAW_HOME)\workspace
WORKSPACE_SKILLS_DIR=$(WORKSPACE_DIR)\skills
BUILTIN_SKILLS_DIR=$(CURDIR)\skills

# Set the platform and architecture for Windows manually
PLATFORM=windows
ARCH=386
BINARY_PATH=$(BUILD_DIR)\$(BINARY_NAME)-$(PLATFORM)-$(ARCH).exe

# Default target
all: build

## generate: Run go generate
generate:
	@echo "Run generate..."
	@$(GO) generate ./... || exit 0
	@echo "Run generate complete"

## build: Build the picoclaw binary for current platform
build: generate
	@echo "Building $(BINARY_NAME) for $(PLATFORM)/$(ARCH)..."
	@if not exist "$(BUILD_DIR)" (mkdir $(BUILD_DIR))
	@$(GO) build $(GOFLAGS) $(LDFLAGS) -o "$(BINARY_PATH)" "$(CMD_DIR)"
	@echo "Build complete: $(BINARY_PATH)"
	@cmd /C "mklink /H $(BUILD_DIR)\$(BINARY_NAME).exe $(BINARY_PATH)" || echo "Linking not supported on your system, skipping."

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@if exist "$(BUILD_DIR)" (rmdir /S /Q "$(BUILD_DIR)")
	@echo "Clean complete"

## vet: Run go vet for static analysis
vet:
	@$(GO) vet ./...

## fmt: Format Go code
fmt:
	@$(GO) fmt ./...

## deps: Download dependencies
deps:
	@$(GO) mod download
	@$(GO) mod verify

## test: Run tests
test:
	@$(GO) test ./...

## install: Install picoclaw to user directory
install: build
	@echo "Installing $(BINARY_NAME)..."
	@if not exist "$(INSTALL_BIN_DIR)" (mkdir $(INSTALL_BIN_DIR))
	@copy "$(BINARY_PATH)" "$(INSTALL_BIN_DIR)\$(BINARY_NAME).exe"
	@echo "Installed binary to $(INSTALL_BIN_DIR)\$(BINARY_NAME).exe"

## uninstall: Remove picoclaw from user directory
uninstall:
	@echo "Uninstalling $(BINARY_NAME)..."
	@del /F /Q "$(INSTALL_BIN_DIR)\$(BINARY_NAME).exe"
	@echo "Removed binary from $(INSTALL_BIN_DIR)\$(BINARY_NAME).exe"

## uninstall-all: Remove picoclaw and all data
uninstall-all:
	@echo "Removing workspace and skills..."
	@powershell Remove-Item -Recurse -Force "$(PICOCLAW_HOME)"
	@echo "Removed workspace: $(PICOCLAW_HOME)"

## help: Show this help message
help:
	@echo "picoclaw Makefile - Windows"
	@echo ""
	@echo "Usage:"
	@echo "  mingw32-make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  make build              # Build for current platform"
	@echo "  make install            # Install to $(INSTALL_BIN_DIR)"
	@echo "  make uninstall          # Remove from $(INSTALL_BIN_DIR)"
	@echo "  make clean              # Remove build artifacts"
	@echo "  make help               # Display help"
	@echo ""
	@echo "Current Configuration:"
	@echo "  Platform: $(PLATFORM)/$(ARCH)"
	@echo "  Binary: $(BINARY_PATH)"
	@echo "  Install Prefix: $(INSTALL_PREFIX)"
	@echo "  Workspace: $(WORKSPACE_DIR)"
