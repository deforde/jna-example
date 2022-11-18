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

cat > HelloWorld.java <<EOF
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
public class HelloWorld {
  public interface CLibrary extends Library {
    CLibrary INSTANCE = (CLibrary)Native.load((Platform.isWindows() ? "msvcrt" : "c"), CLibrary.class);
    void printf(String format, Object... args);
  }
  public static void main(String[] args) {
    CLibrary.INSTANCE.printf("Hello, World\n");
    for (int i=0; i < args.length; i++) {
      CLibrary.INSTANCE.printf("Argument %d: %s\n", i, args[i]);
    }
  }
}
EOF

javac -cp jna.jar:. HelloWorld.java -d build
java -cp jna.jar:build HelloWorld
