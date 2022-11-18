.PHONY: *

all:
	./example.sh

clean:
	git ls-files -o --directory | awk '$$0 !~ /jna\.jar/ {system("rm -rf "$$1)}'
