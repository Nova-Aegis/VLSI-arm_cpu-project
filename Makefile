SRC_DIR = src
TEST_PROGRAM_DIR = test_program

.PHONY : help compile test clean

help :
	@echo "to compile run `make compile`"
	@echo "to test run `make test`"
	@echo "to print this message run `make help`"

compile :
	cd $(SRC_DIR) && make main_tb && mv main_tb ../execute

test :
	cd $(SRC_DIR) && make run_arm

test_program : compile
	./execute $(TEST_PROGRAM_DIR)/sum --vcd=sum.vcd

# The Janitor
clean:
	cd $(SRC_DIR) && make clean
	rm execute
