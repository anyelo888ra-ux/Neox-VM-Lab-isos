export NEOX_VERSION="0.1.0"
export NEOX_EDITION="VM LAB Experimental"

if [ -t 1 ]; then
  printf '\033[1;36m'
  printf 'NEOX %s — %s\n' "$NEOX_VERSION" "$NEOX_EDITION"
  printf '\033[0m'
fi

alias ll='ls -lah'
alias cls='clear'

if [ "$(tty 2>/dev/null)" = "/dev/tty1" ] && [ "$(id -u)" = "0" ]; then
  exec /usr/local/bin/neox
fi
