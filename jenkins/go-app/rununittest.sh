#!/bin/sh
echo "go unit test"
set -x
ls -lrt
go get -d -v golang.org/x/net/html
go get -u github.com/jstemmer/go-junit-report

go test -v 2>&1 > tmp
status=$?
$GOPATH/bin/go-junit-report < tmp > test_output.xml

exit ${status}
