#!/usr/bin/env bash
#
# generate_function_index.sh
#
# Purpose:
#   Generate a Markdown file named "FunctionIndex.md" in each directory containing
#   Swift files, listing function declarations found in that directory's .swift files.
#   This serves as a quick, human-readable index for developers and is ignored by
#   the build system since it's not source code.
#
# Usage:
#   Scripts/generate_function_index.sh [DIR ...]
#
#   - If no DIR arguments are provided, defaults to scanning these roots:
#       Shared iOS macOS UnitTests Tests
#   - The script will skip DerivedData/.build/.git and any existing FunctionIndex.md
#
# Notes:
#   - Uses only POSIX tools available on a stock macOS. No Homebrew deps required.
#   - Enhanced pattern matching for functions, computed properties, initializers, and subscripts
#   - Extracts documentation comments and provides better categorization
#   - Detects extension context and shows what type each function extends
#   - You can add this script to the build workflow to ensure indices stay fresh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Base directory for relative paths and output; defaults to current working directory
BASE_DIR="$(pwd)"

WITH_CHILDREN=0
WITH_DOCS=1
WITH_CATEGORIES=1
WITH_MASTER_INDEX=0
WITH_FULL_SIGNATURES=0
WITH_EXTENSIONS=1

# Default roots if --all is provided
DEFAULT_DIRS=("Framework/Sources/Shared" "Framework/Sources/iOS" "Framework/Sources/macOS")

# Output directory for generated files (outside of source tree)
OUTPUT_BASE_DIR="Development/FunctionIndexes"

# Enhanced regex patterns for different Swift declarations
FUNC_REGEX='^[[:space:]]*(public|internal|private|fileprivate|open)?[[:space:]]*(static|class)?[[:space:]]*func[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\('
PROPERTY_REGEX='^[[:space:]]*(public|internal|private|fileprivate|open)?[[:space:]]*(static|class)?[[:space:]]*var[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*:[[:space:]]*[^{]*\{'
INIT_REGEX='^[[:space:]]*(public|internal|private|fileprivate|open)?[[:space:]]*init[[:space:]]*\('
SUBSCRIPT_REGEX='^[[:space:]]*(public|internal|private|fileprivate|open)?[[:space:]]*(static|class)?[[:space:]]*subscript[[:space:]]*\('

# Extension detection patterns
EXTENSION_REGEX='^[[:space:]]*extension[[:space:]]+([A-Za-z_][A-Za-z0-9_.]*)[[:space:]]*\{'
EXTENSION_PROTOCOL_REGEX='^[[:space:]]*extension[[:space:]]+([A-Za-z_][A-Za-z0-9_.]*)[[:space:]]*:[[:space:]]*([A-Za-z_][A-Za-z0-9_.]*)[[:space:]]*\{'
EXTENSION_WHERE_REGEX='^[[:space:]]*extension[[:space:]]+([A-Za-z_][A-Za-z0-9_.]*)[[:space:]]+where[[:space:]]+([^{]+)[[:space:]]*\{'

# Documentation comment patterns
SINGLE_LINE_DOC_REGEX='^[[:space:]]*///[[:space:]]*(.+)$'
MULTI_LINE_DOC_START_REGEX='^[[:space:]]*/\*\*[[:space:]]*(.+)$'
MULTI_LINE_DOC_END_REGEX='^[[:space:]]*\*/[[:space:]]*$'

color_info="\033[1;34m"
color_warn="\033[1;33m"
color_reset="\033[0m"

log_info() { printf "%b[function-index]%b %s\n" "$color_info" "$color_reset" "$*"; }
log_warn() { printf "%b[function-index]%b %s\n" "$color_warn" "$color_reset" "$*"; }

# Parse flags
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --children|-c)
      WITH_CHILDREN=1
      shift
      ;;
    --all|-a)
      ARGS+=("__USE_DEFAULTS__")
      shift
      ;;
    --no-docs)
      WITH_DOCS=0
      shift
      ;;
    --no-categories)
      WITH_CATEGORIES=0
      shift
      ;;
    --no-extensions)
      WITH_EXTENSIONS=0
      shift
      ;;
    --master-index)
      WITH_MASTER_INDEX=1
      shift
      ;;
    --full-signatures)
      WITH_FULL_SIGNATURES=1
      shift
      ;;
    --help|-h)
      cat <<USAGE
Usage: Scripts/generate_function_index.sh [OPTIONS] [DIR ...]

Options:
  --children, -c        Also generate FunctionIndex.children.md that aggregates only
                        the first level of subdirectories per directory.
  --all, -a             Use default project roots (Shared iOS macOS UnitTests Tests)
                        instead of the current directory.
  --no-docs             Skip extraction of documentation comments
  --no-categories       Skip categorization by access level and type
  --no-extensions       Skip extension context detection and display
  --master-index        Generate a master index linking all FunctionIndex.md files
  --full-signatures     Include complete function signatures (may be verbose)
  --help, -h            Show this help message

DIR ...                 Optional scan roots (relative to current directory). If none
                        provided and --all is not set, defaults to current directory (.).

Examples:
  ./Scripts/generate_function_index.sh --all                    # Scan all default roots
  ./Scripts/generate_function_index.sh --master-index Shared   # Generate master index for Shared
  ./Scripts/generate_function_index.sh --no-docs .             # Skip docs for current directory
  ./Scripts/generate_function_index.sh --no-extensions .       # Skip extension context
USAGE
      exit 0
      ;;
    --)
      shift; break
      ;;
    -*)
      log_warn "Unknown option: $1"
      shift
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#ARGS[@]} -gt 0 ]]; then
  if [[ "${ARGS[0]}" == "__USE_DEFAULTS__" ]]; then
    SCAN_DIRS=("${DEFAULT_DIRS[@]}")
  else
    SCAN_DIRS=("${ARGS[@]}")
  fi
else
  SCAN_DIRS=(".")
fi

normalize_path() {
  local p="$1"
  if [[ "$p" = /* ]]; then
    printf "%s" "$p"
  else
    printf "%s/%s" "$BASE_DIR" "$p"
  fi
}

# Extract documentation comments above a line
extract_documentation() {
  local file="$1"
  local target_line="$2"
  local docs=""
  
  if [[ $WITH_DOCS -eq 0 ]]; then
    return
  fi
  
  # Look for /// comments above the target line
  local line_num=$((target_line - 1))
  while [[ $line_num -gt 0 ]]; do
    local line_content
    line_content=$(sed -n "${line_num}p" "$file" 2>/dev/null || echo "")
    
    if [[ "$line_content" =~ $SINGLE_LINE_DOC_REGEX ]]; then
      docs="${BASH_REMATCH[1]}\n$docs"
      line_num=$((line_num - 1))
    else
      break
    fi
  done
  
  if [[ -n "$docs" ]]; then
    printf "%s" "$docs"
  fi
}

# Categorize function by access level and type
categorize_function() {
  local line="$1"
  local access_level="internal"
  local function_type="function"
  
  if [[ "$line" =~ public ]]; then
    access_level="public"
  elif [[ "$line" =~ private ]]; then
    access_level="private"
  elif [[ "$line" =~ fileprivate ]]; then
    access_level="fileprivate"
  elif [[ "$line" =~ open ]]; then
    access_level="open"
  fi
  
  if [[ "$line" =~ static ]]; then
    function_type="static function"
  elif [[ "$line" =~ class ]]; then
    function_type="class function"
  fi
  
  printf "%s|%s" "$access_level" "$function_type"
}

# Find extension context for a given line number
find_extension_context() {
  local file="$1"
  local target_line="$2"
  local current_extension=""
  local current_protocol=""
  
  if [[ $WITH_EXTENSIONS -eq 0 ]]; then
    return
  fi
  
  # Look backwards from the target line to find the most recent extension
  # Limit search to prevent infinite loops
  local line_num=$((target_line - 1))
  local max_search=50  # Safety limit
  
  while [[ $line_num -gt 0 && $max_search -gt 0 ]]; do
    local line_content
    line_content=$(sed -n "${line_num}p" "$file" 2>/dev/null || echo "")
    
    # Check for extension declaration with protocol
    if [[ "$line_content" =~ $EXTENSION_PROTOCOL_REGEX ]]; then
      current_extension="${BASH_REMATCH[1]}"
      current_protocol="${BASH_REMATCH[2]}"
      break
    # Check for extension declaration with where clause
    elif [[ "$line_content" =~ $EXTENSION_WHERE_REGEX ]]; then
      current_extension="${BASH_REMATCH[1]}"
      # Extract protocol from where clause if present
      local where_clause="${BASH_REMATCH[2]}"
      if [[ "$where_clause" =~ [A-Za-z_][A-Za-z0-9_.]*[[:space:]]*:[[:space:]]*([A-Za-z_][A-Za-z0-9_.]*) ]]; then
        current_protocol="${BASH_REMATCH[1]}"
      fi
      break
    # Check for simple extension declaration
    elif [[ "$line_content" =~ $EXTENSION_REGEX ]]; then
      current_extension="${BASH_REMATCH[1]}"
      break
    fi
    
    line_num=$((line_num - 1))
    max_search=$((max_search - 1))
  done
  
  if [[ -n "$current_extension" ]]; then
    if [[ -n "$current_protocol" ]]; then
      printf "extension %s: %s" "$current_extension" "$current_protocol"
    else
      printf "extension %s" "$current_extension"
    fi
  fi
}

# Generate enhanced function index for a directory
generate_index_for_dir() {
  local dir="$1"
  local dir_name=$(basename "$dir")
  local parent_dir=$(dirname "$dir" | xargs basename 2>/dev/null || echo "")
  
  # Create output directory structure in Development/FunctionIndexes
  local rel_dir="${dir#${BASE_DIR}/}"
  local output_dir="${BASE_DIR}/${OUTPUT_BASE_DIR}/${rel_dir}"
  mkdir -p "$output_dir"
  
  # Create unique filename to prevent build conflicts
  local output_file
  if [[ -n "$parent_dir" ]]; then
    output_file="$output_dir/FunctionIndex_${parent_dir}_${dir_name}.md"
  else
    output_file="$output_dir/FunctionIndex_${dir_name}.md"
  fi
  
  # Validate directory path and output file path length
  if [[ ! -d "$dir" ]]; then
    log_warn "Skipping non-directory path: $dir"
    return
  fi
  
  if (( ${#output_file} > 250 )); then
    log_warn "Output path too long, skipping: ${output_file#${BASE_DIR}/}"
    return
  fi

  # Header
  {
    echo "# Function Index"
    echo
    echo "- **Directory**: ${dir#${BASE_DIR}/}"
    echo "- **Generated**: $(date '+%Y-%m-%d %H:%M:%S %z')"
    echo "- **Script**: Scripts/generate_function_index.sh"
    echo
    echo "This index lists function declarations and other Swift declarations found in this directory's Swift files."
    echo
    if [[ $WITH_CATEGORIES -eq 1 ]]; then
      echo "Functions are categorized by access level and type for better organization."
      echo
    fi
    if [[ $WITH_DOCS -eq 1 ]]; then
      echo "Documentation comments are extracted when available."
      echo
    fi
    if [[ $WITH_EXTENSIONS -eq 1 ]]; then
      echo "Extension context is shown for functions that are part of extensions."
      echo
    fi
    echo "---"
    echo
  } > "$output_file"

  local found_any=0
  local categories=()
  
  # Collect all Swift declarations
  while IFS= read -r -d '' swift_file; do
    [[ "${swift_file##*/}" == "FunctionIndex.md" ]] && continue
    [[ "${swift_file##*/}" =~ ^FunctionIndex_.*\.md$ ]] && continue
    
    local file_declarations=()
    
    # Extract functions
    local func_matches
    func_matches=$(grep -nE "$FUNC_REGEX" "$swift_file" || true)
    if [[ -n "$func_matches" ]]; then
      while IFS= read -r line; do
        local lineno="${line%%:*}"
        local content="${line#*:}"
        local sig
        sig=$(printf "%s" "$content" | sed -E 's/[[:space:]]+/ /g' | sed -E 's/[[:space:]]*\{[[:space:]]*$//')
        
        local docs=""
        if [[ $WITH_DOCS -eq 1 ]]; then
          docs=$(extract_documentation "$swift_file" "$lineno")
        fi
        
        local category=""
        if [[ $WITH_CATEGORIES -eq 1 ]]; then
          category=$(categorize_function "$content")
        fi
        
        local extension_context=""
        if [[ $WITH_EXTENSIONS -eq 1 ]]; then
          extension_context=$(find_extension_context "$swift_file" "$lineno")
        fi
        
        file_declarations+=("function|$lineno|$sig|$docs|$category|$extension_context")
      done <<< "$func_matches"
    fi
    
    # Extract computed properties
    local prop_matches
    prop_matches=$(grep -nE "$PROPERTY_REGEX" "$swift_file" || true)
    if [[ -n "$prop_matches" ]]; then
      while IFS= read -r line; do
        local lineno="${line%%:*}"
        local content="${line#*:}"
        local sig
        sig=$(printf "%s" "$content" | sed -E 's/[[:space:]]+/ /g' | sed -E 's/[[:space:]]*\{[[:space:]]*$//')
        
        local docs=""
        if [[ $WITH_DOCS -eq 1 ]]; then
          docs=$(extract_documentation "$swift_file" "$lineno")
        fi
        
        local category=""
        if [[ $WITH_CATEGORIES -eq 1 ]]; then
          category=$(categorize_function "$content")
        fi
        
        local extension_context=""
        if [[ $WITH_EXTENSIONS -eq 1 ]]; then
          extension_context=$(find_extension_context "$swift_file" "$lineno")
        fi
        
        file_declarations+=("property|$lineno|$sig|$docs|$category|$extension_context")
      done <<< "$prop_matches"
    fi
    
    # Extract initializers
    local init_matches
    init_matches=$(grep -nE "$INIT_REGEX" "$swift_file" || true)
    if [[ -n "$init_matches" ]]; then
      while IFS= read -r line; do
        local lineno="${line%%:*}"
        local content="${line#*:}"
        local sig
        sig=$(printf "%s" "$content" | sed -E 's/[[:space:]]+/ /g' | sed -E 's/[[:space:]]*\{[[:space:]]*$//')
        
        local docs=""
        if [[ $WITH_DOCS -eq 1 ]]; then
          docs=$(extract_documentation "$swift_file" "$lineno")
        fi
        
        local category=""
        if [[ $WITH_CATEGORIES -eq 1 ]]; then
          category=$(categorize_function "$content")
        fi
        
        local extension_context=""
        if [[ $WITH_EXTENSIONS -eq 1 ]]; then
          extension_context=$(find_extension_context "$swift_file" "$lineno")
        fi
        
        file_declarations+=("initializer|$lineno|$sig|$docs|$category|$extension_context")
      done <<< "$init_matches"
    fi
    
    # Extract subscripts
    local subscript_matches
    subscript_matches=$(grep -nE "$SUBSCRIPT_REGEX" "$swift_file" || true)
    if [[ -n "$subscript_matches" ]]; then
      while IFS= read -r line; do
        local lineno="${line%%:*}"
        local content="${line#*:}"
        local sig
        sig=$(printf "%s" "$content" | sed -E 's/[[:space:]]+/ /g' | sed -E 's/[[:space:]]*\{[[:space:]]*$//')
        
        local docs=""
        if [[ $WITH_DOCS -eq 1 ]]; then
          docs=$(extract_documentation "$swift_file" "$lineno")
        fi
        
        local category=""
        if [[ $WITH_CATEGORIES -eq 1 ]]; then
          category=$(categorize_function "$content")
        fi
        
        local extension_context=""
        if [[ $WITH_EXTENSIONS -eq 1 ]]; then
          extension_context=$(find_extension_context "$swift_file" "$lineno")
        fi
        
        file_declarations+=("subscript|$lineno|$sig|$docs|$category|$extension_context")
      done <<< "$subscript_matches"
    fi
    
    if [[ ${#file_declarations[@]} -gt 0 ]]; then
      found_any=1
      local rel="${swift_file#${BASE_DIR}/}"
      echo "## $rel" >> "$output_file"
      
      # Group by category if enabled
      if [[ $WITH_CATEGORIES -eq 1 ]]; then
        local public_funcs=()
        local internal_funcs=()
        local private_funcs=()
        local other_funcs=()
        
        for decl in "${file_declarations[@]}"; do
          IFS='|' read -r type lineno sig docs category extension_context <<< "$decl"
          IFS='|' read -r access_level function_type <<< "$category"
          
          case "$access_level" in
            "public")
              public_funcs+=("$type|$lineno|$sig|$docs|$extension_context")
              ;;
            "internal")
              internal_funcs+=("$type|$lineno|$sig|$docs|$extension_context")
              ;;
            "private")
              private_funcs+=("$type|$lineno|$sig|$docs|$extension_context")
              ;;
            *)
              other_funcs+=("$type|$lineno|$sig|$docs|$extension_context")
              ;;
          esac
        done
        
        # Output by category
        if [[ ${#public_funcs[@]} -gt 0 ]]; then
          echo "### Public Interface" >> "$output_file"
          for decl in "${public_funcs[@]}"; do
            IFS='|' read -r type lineno sig docs extension_context <<< "$decl"
            echo "- **L${lineno}:** \`${sig}\`" >> "$output_file"
            if [[ -n "$extension_context" ]]; then
              echo "  - *${extension_context}*" >> "$output_file"
            fi
            if [[ -n "$docs" ]]; then
              echo "  - *${docs}*" >> "$output_file"
            fi
          done
          echo >> "$output_file"
        fi
        
        if [[ ${#internal_funcs[@]} -gt 0 ]]; then
          echo "### Internal Methods" >> "$output_file"
          for decl in "${internal_funcs[@]}"; do
            IFS='|' read -r type lineno sig docs extension_context <<< "$decl"
            echo "- **L${lineno}:** \`${sig}\`" >> "$output_file"
            if [[ -n "$extension_context" ]]; then
              echo "  - *${extension_context}*" >> "$output_file"
            fi
            if [[ -n "$docs" ]]; then
              echo "  - *${docs}*" >> "$output_file"
            fi
          done
          echo >> "$output_file"
        fi
        
        if [[ ${#private_funcs[@]} -gt 0 ]]; then
          echo "### Private Implementation" >> "$output_file"
          for decl in "${private_funcs[@]}"; do
            IFS='|' read -r type lineno sig docs extension_context <<< "$decl"
            echo "- **L${lineno}:** \`${sig}\`" >> "$output_file"
            if [[ -n "$extension_context" ]]; then
              echo "  - *${extension_context}*" >> "$output_file"
            fi
            if [[ -n "$docs" ]]; then
              echo "  - *${docs}*" >> "$output_file"
            fi
          done
          echo >> "$output_file"
        fi
        
        if [[ ${#other_funcs[@]} -gt 0 ]]; then
          echo "### Other" >> "$output_file"
          for decl in "${other_funcs[@]}"; do
            IFS='|' read -r type lineno sig docs extension_context <<< "$decl"
            echo "- **L${lineno}:** \`${sig}\`" >> "$output_file"
            if [[ -n "$extension_context" ]]; then
              echo "  - *${extension_context}*" >> "$output_file"
            fi
            if [[ -n "$docs" ]]; then
              echo "  - *${docs}*" >> "$output_file"
            fi
          done
          echo >> "$output_file"
        fi
      else
        # Simple listing without categorization
        for decl in "${file_declarations[@]}"; do
          IFS='|' read -r type lineno sig docs category extension_context <<< "$decl"
          echo "- **L${lineno}:** \`${sig}\`" >> "$output_file"
          if [[ -n "$extension_context" ]]; then
            echo "  - *${extension_context}*" >> "$output_file"
          fi
          if [[ -n "$docs" ]]; then
            echo "  - *${docs}*" >> "$output_file"
          fi
        done
        echo >> "$output_file"
      fi
    fi
  done < <(find "$dir" -maxdepth 1 -type f -name '*.swift' -print0)

  if [[ $found_any -eq 0 ]]; then
    echo "_No Swift declarations found in Swift files at this directory level._" >> "$output_file"
  fi
}

# Generate master index linking all FunctionIndex.md files
generate_master_index() {
  # Ensure output directory exists
  mkdir -p "${BASE_DIR}/${OUTPUT_BASE_DIR}"
  local output_file="${BASE_DIR}/${OUTPUT_BASE_DIR}/MASTER_FunctionIndex.md"
  
  {
    echo "# Master Function Index"
    echo
    echo "- **Generated**: $(date '+%Y-%m-%d %H:%M:%S %z')"
    echo "- **Script**: Scripts/generate_function_index.sh --master-index"
    echo
    echo "This master index provides links to all FunctionIndex.md files in the project."
    echo
    echo "---"
    echo
  } > "$output_file"
  
  local index_count=0
  
  # Find all FunctionIndex.md files in the output directory
  while IFS= read -r -d '' index_file; do
    local rel_path="${index_file#${BASE_DIR}/}"
    local dir_path=$(dirname "$rel_path")
    
    echo "## [$dir_path]($rel_path)" >> "$output_file"
    echo "- **Path**: \`$rel_path\`" >> "$output_file"
    echo "- **Generated**: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$index_file" 2>/dev/null || echo "Unknown")" >> "$output_file"
    echo >> "$output_file"
    
    index_count=$((index_count + 1))
  done < <(find "${BASE_DIR}/${OUTPUT_BASE_DIR}" -name "FunctionIndex_*.md" -print0)
  
  echo "---" >> "$output_file"
  echo "**Total Index Files**: $index_count" >> "$output_file"
  
  log_info "Generated master index: $output_file"
}

# Main execution
if [[ $WITH_MASTER_INDEX -eq 1 ]]; then
  generate_master_index
fi

# Discover all subdirectories that contain Swift files under each scan root
for raw in "${SCAN_DIRS[@]}"; do
  abs="$(normalize_path "$raw")"
  if [[ ! -d "$abs" ]]; then
    log_warn "Skipping non-existent directory: $raw"
    continue
  fi
  log_info "Scanning root: ${abs#${BASE_DIR}/}"

  # Find directories with Swift files, ignoring common build/temp folders
  while IFS= read -r dir; do
    # Skip empty
    [[ -z "$dir" ]] && continue
    generate_index_for_dir "$dir"
    # Note: The actual filename is now unique per directory
    log_info "Wrote: ${dir#${BASE_DIR}/}/FunctionIndex_*.md"
    if [[ $WITH_CHILDREN -eq 1 ]]; then
      # Note: Children index generation would need similar enhancement
      log_info "Children index generation not yet enhanced for new features"
    fi
  done < <(find "$abs" \
            -type f -name '*.swift' \
            ! -name 'FunctionIndex.md' \
            ! -path '*/.git/*' \
            ! -path '*/.build/*' \
            ! -path '*/DerivedData/*' \
            -print0 \
            | xargs -0 -n1 dirname \
            | sort -u)
done

log_info "Enhanced function index generation complete."
if [[ $WITH_MASTER_INDEX -eq 1 ]]; then
  log_info "Master index generated: MASTER_FunctionIndex.md"
fi


