.PHONY: *

all:
	./example.sh

clean:
	git ls-files -o --directory | xargs -n1 rm -rf
