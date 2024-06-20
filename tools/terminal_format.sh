# Only apply formatting when the script is running in a terminal (versus on CI).
if [ -n "$TERM" ]; then
    bold=$(tput bold)
    normal=$(tput sgr0)
else
    bold=""
    normal=""
fi
