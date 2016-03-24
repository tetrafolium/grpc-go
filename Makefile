.PHONY: \
	all \
	deps \
	updatedeps \
	testdeps \
	updatetestdeps \
	build \
	proto \
	test \
	testrace \
	clean \

all: test testrace

deps:
	go get -d -v github.com/tetrafolium/grpc-go/...

updatedeps:
	go get -d -v -u -f github.com/tetrafolium/grpc-go/...

testdeps:
	go get -d -v -t github.com/tetrafolium/grpc-go/...

updatetestdeps:
	go get -d -v -t -u -f github.com/tetrafolium/grpc-go/...

build: deps
	go build github.com/tetrafolium/grpc-go/...

proto:
	@ if ! which protoc > /dev/null; then \
		echo "error: protoc not installed" >&2; \
		exit 1; \
	fi
	go get -v github.com/golang/protobuf/protoc-gen-go
	for file in $$(git ls-files '*.proto'); do \
		protoc -I $$(dirname $$file) --go_out=plugins=grpc:$$(dirname $$file) $$file; \
	done

test: testdeps
	go test -v -cpu 1,4 github.com/tetrafolium/grpc-go/...

testrace: testdeps
	go test -v -race -cpu 1,4 github.com/tetrafolium/grpc-go/...

clean:
	go clean github.com/tetrafolium/grpc-go/...

coverage: testdeps
	./coverage.sh --coveralls
