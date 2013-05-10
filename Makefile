LUABIN		?= lua
LUA_VERSION     ?= 5.1
PREFIX          ?= /usr
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR     ?= $(PREFIX)/lib
LUA_CMODULE_DIR ?= $(DESTDIR)$(PREFIX)/lib/lua/$(LUA_VERSION)
LUA_MODULE_DIR  ?= $(DESTDIR)$(PREFIX)/share/lua/$(LUA_VERSION)
LUA_BIN_DIR     ?= $(DESTDIR)$(PREFIX)/bin
CC              ?= gcc
INSTALL         ?= install
CFLAGS          += -O2 -fPIC
LDFLAGS         += -shared
INCLUDES         = -I$(LUA_INCLUDE_DIR)
INC_LIBS         = -L$(LUA_LIB_DIR) -lfann
LF		 = $(INC_LIBS) $(LDFLAGS)
CF		 = $(CFLAGS) $(INCLUDES)

all: module

module: src/fann.so

src/fann.so: src/fann.o
	$(CC) $(LF) $^ -o $@

src/fann.o: src/fann.c
	$(CC) $(CF) -c $^ -o $@

docs: doc/luafann.html

doc/luafann.html: src/fann.c
	-@mkdir -p doc
	$(LUABIN) doc.lua < $< > $@

install: all
	$(INSTALL) -d $(LUA_CMODULE_DIR)
	$(INSTALL) src/fann.so $(LUA_CMODULE_DIR)

test: all
	-@ln -sf ../src/fann.so test/
	-@cd test && $(LUABIN) module.lua

clean:
	-@rm -f src/*.o src/*.so test/*.net doc/luafann.html test/fann.so
