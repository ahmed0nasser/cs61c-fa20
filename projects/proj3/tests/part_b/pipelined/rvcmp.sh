#!/usr/bin/env bash
# rvcmp.sh — RISC-V Simulation Comparator
# Usage: ./rvcmp.sh <testname> [--mismatch-only|-m]

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

# ── Args ──────────────────────────────────────────────────────
TESTNAME="${1:-}"
MISMATCH_ONLY=false
[[ "${2:-}" == "--mismatch-only" || "${2:-}" == "-m" ]] && MISMATCH_ONLY=true

if [[ -z "$TESTNAME" ]]; then
  echo "Usage: $0 <testname> [--mismatch-only|-m]"
  exit 1
fi

# ── Build debug file ──────────────────────────────────────────
DEBUG="debug.txt"
echo '## PROGRAM' > "$DEBUG"
cat "./inputs/${TESTNAME}.s" >> "$DEBUG"
echo >> "$DEBUG"
echo '## REFERENCE' >> "$DEBUG"
./binary_to_hex_cpu.py "reference_output/cpu-${TESTNAME}-ref.out" >> "$DEBUG"
echo >> "$DEBUG"
echo '## STUDENT' >> "$DEBUG"
./binary_to_hex_cpu.py "student_output/cpu-${TESTNAME}-student.out" >> "$DEBUG"

# ── Parse sections ────────────────────────────────────────────
mapfile -t ALL_LINES < "$DEBUG"

section=""
raw_prog=(); ref=(); stu=()

for line in "${ALL_LINES[@]}"; do
  line="${line#"${line%%[![:space:]]*}"}"  # trim leading whitespace
  [[ -z "$line" ]] && continue
  case "$line" in
    "## PROGRAM")   section="prog" ;;
    "## REFERENCE") section="ref"  ;;
    "## STUDENT")   section="stu"  ;;
    *)
      case "$section" in
        prog) raw_prog+=("$line") ;;
        ref)  ref+=("$line")      ;;
        stu)  stu+=("$line")      ;;
      esac
      ;;
  esac
done

# ── Filter program: keep only real instructions ───────────────
# Skip: blank-after-trim, pure comment lines (#...), label-only lines (word:)
# Also strip inline comments from kept lines
prog=()        # instructions only (indexed by PC order)
prog_full=()   # raw source lines for display (labels + instructions)

is_label_only() {
  # matches lines like "start:" or "bad-loop:" (optionally with trailing spaces)
  [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_\-]*:[[:space:]]*$ ]]
}

is_pure_comment() {
  [[ "$1" =~ ^# ]]
}

strip_comment() {
  # Remove trailing #... comment, preserve the instruction
  echo "$1" | sed 's/[[:space:]]*#.*$//' | sed 's/[[:space:]]*$//'
}

for line in "${raw_prog[@]}"; do
  if is_pure_comment "$line" || is_label_only "$line"; then
    prog_full+=("${DIM}${line}${RESET}")   # show in listing but don't count
  else
    clean=$(strip_comment "$line")
    prog+=("$clean")
    prog_full+=("$clean")
  fi
done

total="${#ref[@]}"
if [[ $total -eq 0 ]]; then
  echo -e "${RED}Error: no REFERENCE lines found.${RESET}"
  exit 1
fi

# ── Extract a register value from a line ──────────────────────
get_val() {
  echo "$1" | grep -oP "${2}:\s+\K[0-9a-fA-F]+" || echo "?"
}

# ── Get register names from first ref line ────────────────────
REG_NAMES=()
while read -r key; do
  REG_NAMES+=("$key")
done < <(echo "${ref[0]}" | grep -oP '\w+(?=:\s+[0-9a-fA-F]+)')

# ── Header ────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}━━━ RISC-V Simulation Comparator ━━━${RESET}"
echo -e "${DIM}Test: $TESTNAME${RESET}"
echo ""

# ── Print program listing (full source, labels shown dimmed) ──
echo -e "${BOLD}${YELLOW}── Program ──────────────────────────────${RESET}"
instr_idx=0
for line in "${raw_prog[@]}"; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  if is_pure_comment "$trimmed" || is_label_only "$trimmed"; then
    printf "     ${DIM}%s${RESET}\n" "$trimmed"
  else
    clean=$(strip_comment "$trimmed")
    printf "${DIM}%3d${RESET}  %s\n" "$instr_idx" "$clean"
    (( instr_idx++ )) || true
  fi
done
echo ""

# ── Simulation steps ──────────────────────────────────────────
echo -e "${BOLD}${CYAN}── Simulation Steps ─────────────────────${RESET}"
echo ""

match_count=0
mismatch_count=0
first_mismatch=-1

for (( i=0; i<total; i++ )); do
  ref_line="${ref[$i]:-}"
  stu_line="${stu[$i]:-}"
  prog_line="${prog[$i]:-<no instruction>}"

  # Find differing registers
  diffs=()
  for reg in "${REG_NAMES[@]}"; do
    rv=$(get_val "$ref_line" "$reg")
    sv=$(get_val "$stu_line" "$reg")
    [[ "$rv" != "$sv" ]] && diffs+=("$reg")
  done

  ts=$(get_val "$ref_line" "Time_Step")
  has_diff=false
  [[ ${#diffs[@]} -gt 0 ]] && has_diff=true

  if $has_diff; then
    (( mismatch_count++ )) || true
    [[ $first_mismatch -eq -1 ]] && first_mismatch=$i
  else
    (( match_count++ )) || true
  fi

  # Filter
  $MISMATCH_ONLY && ! $has_diff && continue

  # ── Row output ────────────────────────────────────────────
  if $has_diff; then
    echo -e "${RED}${BOLD}✗ Step $ts${RESET}  ${DIM}${prog_line}${RESET}"
  else
    echo -e "${GREEN}✓ Step $ts${RESET}  ${DIM}${prog_line}${RESET}"
  fi

  # Print registers: dim if same, highlight diffs as ref→student
  line_out=""
  for reg in "${REG_NAMES[@]}"; do
    rv=$(get_val "$ref_line" "$reg")
    sv=$(get_val "$stu_line" "$reg")
    if [[ "$rv" != "$sv" ]]; then
      line_out+="  ${BOLD}${reg}${RESET}: ${GREEN}${rv}${RESET}→${RED}${sv}${RESET}"
    else
      line_out+="  ${DIM}${reg}:${rv}${RESET}"
    fi
  done
  echo -e "$line_out"
  echo ""
done

# ── Summary ───────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}━━━ Summary ━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
pct=$(( match_count * 100 / total ))
echo -e "  Steps:     ${BOLD}$total${RESET}"
echo -e "  Match:     ${GREEN}${BOLD}$match_count${RESET}"
echo -e "  Mismatch:  ${RED}${BOLD}$mismatch_count${RESET}"
echo -e "  Score:     ${BOLD}${pct}%${RESET}"
if [[ $first_mismatch -ne -1 ]]; then
  echo -e "  First bad: ${YELLOW}Step $first_mismatch  →  ${prog[$first_mismatch]:-?}${RESET}"
fi
echo ""
