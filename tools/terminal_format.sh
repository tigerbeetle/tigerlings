# Only apply formatting when the script is running in a terminal (versus on CI).
if [ -n "$TERM" ] && command -v tput >/dev/null 2>&1; then
    bold=$(tput bold)
    normal=$(tput sgr0)
else
    bold=""
    normal=""
fi
