.PHONY: all update clean backup-tar reuse-tar

all:
	@echo "To download and build the cache use the following command:"
	@echo "make reuse-tar && make update GSA_PATH=/path/to/gsa && make backup-tar"

update: cache.tar.xz cleanup

yarn.lock:
	cp -v "$(GSA_PATH)/gsa/yarn.lock" .

package.json:
	cp -v "$(GSA_PATH)/gsa/package.json" .

cache: yarn.lock package.json
	yarn install --cache-folder=./cache
	rm -rf ./cache/v4/.tmp/
	touch ./cache

cleanup:
	rm -f yarn.lock package.json
	rm -rf node_modules
	rm -rf cache

clean: cleanup
#	rm cache.tar.xz

cache.tar.xz: cache
	tar -C cache/v4 -cJf cache.tar.xz .

backup-tar:
	cp -v cache.tar.xz ../

reuse-tar:
	cp -v ../cache.tar.xz .
	mkdir -p cache/v4
	tar -C cache/v4 -xJf cache.tar.xz
