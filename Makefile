.PHONY: dist
dist:
	@mkdir -p ./bin
	@rm -f ./bin/*
	GOOS=darwin  GOARCH=amd64 go build -o ./bin/goose-darwin64       ./cmd/goose
	GOOS=linux   GOARCH=amd64 go build -o ./bin/goose-linux64        ./cmd/goose
	GOOS=linux   GOARCH=386   go build -o ./bin/goose-linux386       ./cmd/goose
	GOOS=windows GOARCH=amd64 go build -o ./bin/goose-windows64.exe  ./cmd/goose
	GOOS=windows GOARCH=386   go build -o ./bin/goose-windows386.exe ./cmd/goose

test-packages:
	go test -race -v $$(go list ./... | grep -v -e /tests -e /bin -e /cmd -e /examples)

test-e2e: test-e2e-postgres test-e2e-mysql

test-e2e-postgres:
	go test -race -v ./tests/e2e -dialect=postgres

test-e2e-mysql:
	go test -race -v ./tests/e2e -dialect=mysql

test-clickhouse:
	go test -timeout=10m -count=1 -race -v ./tests/clickhouse -test.short

docker-cleanup:
	docker stop -t=0 $$(docker ps --filter="label=goose_test" -aq)
