can_run_lsb_release = $(shell lsb_release -a 2>/dev/null)

ifeq ($(strip $(can_run_lsb_release)),)
$(error Cannot execute lsb_release command.  Please install lsb_release.)
endif

OS            = $(shell lsb_release -si)
VERSION       = $(shell lsb_release -sr)
ARCH          = $(shell uname -m)
MAJOR_VERSION = $(shell echo $(VERSION) | sed -e 's/\..*//')
MINOR_VERSION = $(shell echo $(VERSION) | awk -F'.' '{print $$2}')

# default vars
USE_MOD_PYTHON = 0
USE_MOD_WSGI   = 0
USE_PYTHON2    = 0
USE_PYTHON3    = 0

########## Scientific Linux 5.0 - 5.7 ##########
# Scientific Linux older than or equal to 5.7 returns ScientificSL
# Scientific Linux newer than or equal to 5.8 returns Scientific

ifeq ($(strip $(OS)),ScientificSL)
    WWW_DOCUMENT_ROOT = /var/www/html
    HTTPD_CONF_DIR    = /etc/httpd/conf.d
    USE_MOD_PYTHON    = 1
endif

########## Scientific Linux 5.8 - , 7.x ##########
ifeq ($(strip $(OS)),Scientific)
    WWW_DOCUMENT_ROOT = /var/www/html
    HTTPD_CONF_DIR    = /etc/httpd/conf.d
    ifeq ($(strip $(MAJOR_VERSION)),5)
        USE_MOD_PYTHON    = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
    endif
    ifeq ($(strip $(MAJOR_VERSION)),6)
        USE_MOD_WSGI      = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python-config
    endif
    ifeq ($(strip $(MAJOR_VERSION)),7)
        USE_MOD_WSGI      = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
        ifeq ($(shell test $(MINOR_VERSION) -gt 6; echo $$?),0)
            USE_PYTHON2      = 0
            USE_PYTHON3      = 1
            PYTHON_EXEC_FILE = python3
            PYTHON_CONFIG    = python3-config
        endif
    endif
endif

########## Scientific Linux CERN ##########
ifeq ($(strip $(OS)),ScientificCERNSLC)
    WWW_DOCUMENT_ROOT = /var/www/html
    HTTPD_CONF_DIR    = /etc/httpd/conf.d
    ifeq ($(strip $(MAJOR_VERSION)),5)
        USE_MOD_PYTHON    = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
    endif
    ifeq ($(strip $(MAJOR_VERSION)),6)
        USE_MOD_WSGI      = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
    endif
endif
# CERN CentOS 7 is like a CentOS 7

########## CentOS ##########
ifeq ($(strip $(OS)),CentOS)
WWW_DOCUMENT_ROOT = /var/www/html
HTTPD_CONF_DIR    = /etc/httpd/conf.d
    ifeq ($(strip $(MAJOR_VERSION)),5)
        USE_MOD_PYTHON    = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
    endif
    ifeq ($(strip $(MAJOR_VERSION)),6)
        USE_MOD_WSGI      = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python-config
    endif
    ifeq ($(strip $(MAJOR_VERSION)),7)
        USE_MOD_WSGI      = 1
        USE_PYTHON2       = 1
        PYTHON_EXEC_FILE  = python2
        PYTHON_CONFIG     = python2-config
        # Use python3 on CentOS 7.7 and later
        ifeq ($(shell test $(MINOR_VERSION) -gt 6; echo $$?),0)
            USE_PYTHON2 = 0
            USE_PYTHON3 = 1
            PYTHON_EXEC_FILE  = python3
            PYTHON_CONFIG     = python3-config
        endif
    endif
    ifeq ($(strip $(MAJOR_VERSION)),8)
        USE_MOD_WSGI      = 1
        USE_PYTHON3       = 1
        PYTHON_EXEC_FILE  = python3
        PYTHON_CONFIG     = python3-config
    endif
endif

########## Fedora ##########
ifeq ($(strip $(OS)),Fedora)
WWW_DOCUMENT_ROOT = /var/www/html
HTTPD_CONF_DIR    = /etc/httpd/conf.d
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python3
PYTHON_CONFIG     = python3-config
endif

########## Debian ##########
ifeq ($(strip $(OS)),Debian)
WWW_DOCUMENT_ROOT = /var/www
HTTPD_CONF_DIR    = /etc/apache2/conf.d
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python3
PYTHON_CONFIG     = python3-config
endif

########## Ubuntu ##########
ifeq ($(strip $(OS)),Ubuntu)
WWW_DOCUMENT_ROOT = /var/www
HTTPD_CONF_DIR    = /etc/apache2/conf.d
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python3
PYTHON_CONFIG     = python3-config
endif

########## ArchLinux  ##########
ifeq ($(strip $(OS)),archlinux)
WWW_DOCUMENT_ROOT = /srv/http
HTTPD_CONF_DIR    = /etc/httpd/conf/extra
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python
PYTHON_CONFIG     = python-config
endif

########## ArchLinux (lsb_release -si output changed) ##########
ifeq ($(strip $(OS)),arch)
WWW_DOCUMENT_ROOT = /srv/http
HTTPD_CONF_DIR    = /etc/httpd/conf/extra
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python
PYTHON_CONFIG     = python-config
endif

########## Raspbian ##########
ifeq ($(strip $(OS)),Raspbian)
WWW_DOCUMENT_ROOT = /var/www/html
HTTPD_CONF_DIR    = /etc/apache2/conf-available
USE_MOD_WSGI      = 1
USE_PYTHON3       = 1
PYTHON_EXEC_FILE  = python3
PYTHON_CONFIG     = python3-config
endif

########## Unknown ##########
ifeq ($(strip $(WWW_DOCUMENT_ROOT)),)
WWW_DOCUMENT_ROOT = /
HTTPD_CONF_DIR    = /
USE_MOD_WSGI      = 1
endif

# all target for testing #
#all:
#       @echo "os:" $(OS)
#       @echo "version:" $(VERSION)
#       @echo "arch:" $(ARCH)
#       @echo "major_version:" $(MAJOR_VERSION)
#       @echo "httpd_document_root:" $(HTTPD_DOCUMENT_ROOT)
#       @echo "mod_python:" $(USE_MOD_PYTHON)
#       @echo "mod_wsgi:" $(USE_MOD_WSGI)
