GENERATES = prog README prog-a prog-so liboutput_static.a liboutput.so
TRASH = *.o *~ o.* *.out
CFLAGS=-fPIC
ARGS = "" "arg1" "arg1 arg2 arg3"

README: prog
	./$< 2> $@

all: README prog prog-a prog-so

liboutput_static.a: fun.o const.o
	ar -rcs $@ $^

liboutput.so: fun.o const.o
	cc -shared $^ -o $@

prog:   const.o fun.o prog.o
	cc $^ -o $@

prog-a: prog.o liboutput_static.a
	cc -L. $^ -loutput_static -o $@

prog-so: prog.o liboutput.so
	cc -L. $^ -loutput -o $@

test: prog prog-a prog-so
	@for args in $(ARGS); do \
		for prog in $^; do \
			LD_LIBRARY_PATH="." ./$$prog $$args > $$prog.out 2>&1; \
		done; \
		echo "Testing $$args:"; \
		cmp prog.out prog-a.out && echo $$?; \
		cmp prog.out prog-so.out && echo $$?; \
		cmp prog-a.out prog-so.out && echo $$?; \
	done;

clean:
	rm -f $(TRASH)

distclean:      clean
	rm -rf $(GENERATES)