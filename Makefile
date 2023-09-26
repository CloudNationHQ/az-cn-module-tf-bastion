.PHONY: test test_extended

export TF_PATH

test:
	cd tests && go test -v -timeout 61m -run TestApplyNoError/$(TF_PATH) ./bastion_test.go

test_extended:
	cd tests && env go test -v -timeout 61m -run TestBastion ./bastion_extended_test.go
