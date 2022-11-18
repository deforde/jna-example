#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(realpath ${0%/*})
cd $SCRIPT_DIR

cat > foo.h <<EOF
int foo(void);
EOF

cat > foo.c <<EOF
int foo(void) {
  return 42;
}
EOF

gcc --shared foo.c -o libfoo.so
