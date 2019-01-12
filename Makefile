.PHONY: all lcpg test clean

GOPATH := $(CURDIR)/_vendor:$(CURDIR)

export GOPATH

all: lcpg

lcpg:
	go install cmds/lcpg

test:
	go test -v ./...

clean:
	rm -rf $(CURDIR)/bin
	rm -rf $(CURDIR)/pkg
