APP_ROOT			= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/../../../..
C_SRC				= $(APP_ROOT)/cpp
PYTHON_SRC			= $(APP_ROOT)/python
JAVSCRIPT_SRC		= $(APP_ROOT)/javascript
MAST_SRC			= $(C_SRC)/wniemiec/mobilex/mast
EXPORT				= $(MAST_SRC)/export
DATA				= $(MAST_SRC)/data
SEMANTIC			= $(MAST_SRC)/semantic
SYNTAX				= $(MAST_SRC)/syntax
TESTDIR				= $(APP_ROOT)/../test/cpp
LIB					= $(APP_ROOT)/../../lib
LIB_CPP				= $(LIB)/cpp
FLEX_FILE			= $(SYNTAX)/scanner.l
BISON_FILE			= $(SEMANTIC)/parser.y
OBJS				= $(SYNTAX)/lex.yy.o \
					  $(SEMANTIC)/parser.tab.o \
					  $(MAST_SRC)/main.o \
					  $(DATA)/text/string_utils.o \
					  $(DATA)/n_tree/n_tree.o \
					  $(EXPORT)/DotExport.o \
					  $(LIB_CPP)/StringUtils/StringUtils.o
TMP_SRC				= $(SYNTAX)/lex.yy.c $(SEMANTIC)/parser.tab.c $(SEMANTIC)/parser.tab.h
OUT					= $(MAST_SRC)/mast_runner
CC					= gcc 
FLAGS				= -c
LFLAGS				= -lfl -lstdc++ -lstdc++fs

all:
		bison -d $(BISON_FILE) -o $(SEMANTIC)/parser.tab.c
		flex -o $(SYNTAX)/lex.yy.c $(FLEX_FILE) 
		$(MAKE) -C $(DATA)/text
		$(MAKE) -C $(DATA)/n_tree
		$(CC) -c $(SYNTAX)/lex.yy.c -o $(SYNTAX)/lex.yy.o
		$(CC) -c $(SEMANTIC)/parser.tab.c -o $(SEMANTIC)/parser.tab.o
		$(CC) -c $(EXPORT)/DotExport.cpp -o $(EXPORT)/DotExport.o
		$(CC) -c $(MAST_SRC)/main.cpp -o $(MAST_SRC)/main.o
		$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

clean:
		mv $(LIB) $(LIB)_
		rm -f $(OBJS) $(TMP_SRC) $(OUT) $(SEMANTIC)/parser $(SEMANTIC)/parser.output *.ast *.dot
		mv $(LIB)_ $(LIB)
		$(MAKE) -C $(DATA)/n_tree clean
		$(MAKE) -C $(DATA)/text clean
		cmake --build $(TESTDIR) --target clean-all

debug:
		bison -v -d $(BISON_FILE) -o $(SEMANTIC)/parser.tab.c
		flex -o $(SYNTAX)/lex.yy.c $(FLEX_FILE) 
		$(MAKE) -C $(DATA)/text
		$(MAKE) -C $(DATA)/n_tree
		$(CC) -c $(SYNTAX)/lex.yy.c -o $(SYNTAX)/lex.yy.o
		$(CC) -c $(SEMANTIC)/parser.tab.c -o $(SEMANTIC)/parser.tab.o
		$(CC) -c $(MAST_SRC)/main.c -o $(MAST_SRC)/main.o
		$(CC) $(OBJS) -o $(OUT) $(LFLAGS)

compilation:
		$(OUT) $(file) $(output) < $(file)

test:
	cmake $(TESTDIR)/CMakeLists.txt
	make -C $(TESTDIR)
	$(TESTDIR)/runTests

