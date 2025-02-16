# Remove the trailing / so we can just make -B full rather than adding the slash
SUBDIRS := $(patsubst %/, %, $(wildcard */))

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@
