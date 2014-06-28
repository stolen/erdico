APP = erdico
INSTALLROOT = $(CURDIR)/debian/$(APP)

all:
	$(MAKE) -C ../..

install:
	mkdir -p $(INSTALLROOT)/usr/lib/
	cp -a ../../_rel/$(APP) $(INSTALLROOT)/usr/lib/
	cp conf_erdico.sh $(INSTALLROOT)/usr/lib/$(APP)/bin/
	mkdir -p $(INSTALLROOT)/var/log/$(APP)
	mkdir -p $(INSTALLROOT)/var/lib/$(APP)
	mkdir -p $(INSTALLROOT)/etc/
	cp $(APP).conf $(INSTALLROOT)/etc/
	mkdir -p $(INSTALLROOT)/etc/init/
	cp upstart.conf $(INSTALLROOT)/etc/init/$(APP).conf

deb:
	rm -f ../$(APP)_*.* # clean
	debuild             # build new package
