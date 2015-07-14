CONTIKI_PROJECT = erbr
all: $(CONTIKI_PROJECT)

CONTIKI= ../..
CFLAGS += -DPROJECT_CONF_H=\"project-conf.h\"

#Contiki IPv6 Configurations
WITH_UIP6=1
UIP_CONF_IPV6=1

# IPv6 make config disappeared completely
CFLAGS += -DUIP_CONF_IPV6=1
# variable for Makefile.include
CFLAGS += -DUIP_CONF_IPV6_RPL=1
#linker optimization
SMALL=1

# REST Engine shall use Erbium CoAP implementation
APPS += er-coap
APPS += rest-engine

# project directories
PROJECTDIRS += rplinfo
PROJECT_SOURCEFILES += rplinfo.c slip-bridge.c

ifeq ($(PREFIX),)
 PREFIX = aaaa::1/64
endif

include $(CONTIKI)/Makefile.include

$(CONTIKI)/tools/tunslip6:	$(CONTIKI)/tools/tunslip6.c
	(cd $(CONTIKI)/tools && $(MAKE) tunslip6)

connect-router:	$(CONTIKI)/tools/tunslip6
	sudo $(CONTIKI)/tools/tunslip6 $(PREFIX)

connect-router-cooja:	$(CONTIKI)/tools/tunslip6
	sudo $(CONTIKI)/tools/tunslip6 -a 127.0.0.1 $(PREFIX)