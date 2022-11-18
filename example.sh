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

if [[ ! -f jna.jar ]]; then
  curl -L https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.12.1/jna-5.12.1.jar -o jna.jar
fi

cat > Foo.java <<EOF
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
public class Foo {
  public interface CLibrary extends Library {
    CLibrary INSTANCE = (CLibrary)Native.load("foo", CLibrary.class);
    int foo();
  }
  public static void main(String[] args) {
    int ans = CLibrary.INSTANCE.foo();
    System.out.println(ans);
  }
}
EOF

javac -cp jna.jar:. Foo.java -d build
RET=$(java -Djna.library.path=$PWD -cp jna.jar:build Foo)
if [[ $RET != "42" ]]; then
  echo "Failed!"
  exit 1
fi
echo "OK"
