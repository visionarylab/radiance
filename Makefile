CC = gcc
CXX = g++

# Files to include
C_SRC  = $(wildcard core/*.c)
C_SRC += $(wildcard lib/*.c)
C_SRC += $(wildcard lib/lux/src/*.c)
CPP_SRC += $(wildcard core/*.cpp)

C_INC  = $(wildcard core/*.h)
C_INC += $(wildcard lib/*.h)
C_INC += $(wildcard lib/lux/inc/*.h)

OBJECTS = $(patsubst %.c,%.o,$(C_SRC))
OBJECTS += $(patsubst %.cpp,%.o,$(CPP_SRC))
DEPS = $(OBJECTS:.o=.d)

INC  = -Icore -Ilib/lux/inc -Ilib -L/usr/local/lib
LIB  = -lSDL -lSDL_ttf -lSDL_gfx -lm -lpthread -lportaudio -lvamp-hostsdk -lportmidi -lporttime

# Assembler, compiler, and linker flags
CXXFLAGS  = -g -O0 $(INC) -Wall 
CFLAGS = $(CXXFLAGS) -std=c99
LFLAGS  = $(CXXFLAGS)

-include $(DEPS)
%.d : %.c
	@$(CXX) $(CXXFLAGS) $< -MM -MT $(@:.d=.o) >$@
%.d : %.cpp
	@$(CXX) $(CXXFLAGS) $< -MM -MT $(@:.d=.o) >$@

# Targets
.PHONY: all
all: beat-off

.PHONY: clean
clean:
	-rm -f $(OBJECTS) $(DEPS) beat-off

beat-off: $(OBJECTS)
	$(CXX) $(LFLAGS) -g -o beat-off $(OBJECTS) $(LIB)


#%.o: %.c $(C_INC)
#	gcc $(CFLAGS) -std=c99 -c -o $@ $<
#%.o: %.cpp
#	g++ $(CFLAGS) -c -o $@ $<

.DEFAULT_GOAL := beat-off
