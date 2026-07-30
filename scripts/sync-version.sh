#!/bin/bash

# This script synchronizes the version number from the root VERSION file
# to all platform-specific implementation files.

# Ensure we are in the root directory
if [ ! -f "VERSION" ]; then
    echo "Error: VERSION file not found in current directory."
    exit 1
fi

VERSION=$(cat VERSION | tr -d '[:space:]')
echo "Synchronizing version: $VERSION"

# 1. Rust (wakem-r) - Update [workspace.package] version in Cargo.toml
if [ -f "wakem-r/Cargo.toml" ]; then
    echo "Updating Rust (wakem-r/Cargo.toml)..."
    sed -i "s/^version = \".*\"/version = \"$VERSION\"/" wakem-r/Cargo.toml
fi

# 2. Go (wakem-g) - Update VERSION constant in pkg/core/version.go
if [ -f "wakem-g/pkg/core/version.go" ]; then
    echo "Updating Go (wakem-g/pkg/core/version.go)..."
    sed -i "s/const VERSION = \".*\"/const VERSION = \"$VERSION\"/" wakem-g/pkg/core/version.go
fi

# 3. Kotlin (wakem-k) - Update VERSION constant in BuildInfo.kt
KOTLIN_BUILD_INFO="wakem-k/core/src/commonMain/kotlin/com/wakem/core/BuildInfo.kt"
if [ -f "$KOTLIN_BUILD_INFO" ]; then
    echo "Updating Kotlin ($KOTLIN_BUILD_INFO)..."
    sed -i "s/const val VERSION = \".*\"/const val VERSION = \"$VERSION\"/" "$KOTLIN_BUILD_INFO"
fi

# 4. TypeScript (wakem-t) - Update package.json and BuildInfo.ts
if [ -f "wakem-t/package.json" ]; then
    echo "Updating TypeScript (wakem-t/package.json)..."
    sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" wakem-t/package.json
fi

TS_BUILD_INFO="wakem-t/src/core/BuildInfo.ts"
if [ -f "$TS_BUILD_INFO" ]; then
    echo "Updating TypeScript ($TS_BUILD_INFO)..."
    sed -i "s/VERSION: \".*\"/VERSION: \"$VERSION\"/" "$TS_BUILD_INFO"
fi

echo "Successfully synchronized all versions to $VERSION"
