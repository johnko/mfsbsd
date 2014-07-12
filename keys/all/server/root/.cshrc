##### .cshrc

set path = ($HOME/bin /server/bin /usr/local/sbin /usr/local/bin /sbin /bin /usr/sbin /usr/bin /usr/games /usr/libexec)

# A righteous umask
umask 077

source ~/.csh_aliases

setenv  KRB5CCNAME ~/.krb5tmp
setenv  EDITOR  vi
setenv  PAGER  "/usr/bin/less -erX"
setenv  BLOCKSIZE  K
setenv  BATCH yes
setenv  FORCE_PKG_REGISTER yes
setenv  RED       "%{\033[0;31m%}"
setenv  GREEN     "%{\033[0;32m%}"
setenv  YELLOW    "%{\033[0;33m%}"
setenv  BLUE      "%{\033[0;34m%}"
setenv  PURPLE    "%{\033[0;35m%}"
setenv  CYAN      "%{\033[0;36m%}"
setenv  WHITE     "%{\033[0;37m%}"
setenv  BOLD      ""
setenv  RESET     "%{\033[0m%}"
setenv  ROOTC     "%{\033[0;32m%}"

if ( ! $?MANPATH ) then
setenv MANPATH /usr/local/man:/usr/man:/usr/share/man:/usr/X11R6/man
else
setenv MANPATH /usr/local/man:/usr/man:/usr/share/man:/usr/X11R6/man:$MANPATH
endif

if ($?prompt) then
  if ($uid == 0) then
    set user = root
    setenv  ROOTC     "%{\033[41;37m%}"
  endif
  set prompt = "%b${PURPLE}%Y-%W-%D %P  %?"'\n'"${ROOTC}%n${CYAN} %m ${YELLOW}%/"'\n'"${PURPLE}%#${RESET} "
  set promptchars = "%#"
  set filec
  set noding
  #don't set enhance if you want to auto complete files with _ in their name
  #set complete = enhance
  set history = 1000
  set savehist = (1000 merge)
  set autolist = ambiguous
  # Use history to aid expansion
  set autoexpand
  set autorehash
  if ( $?tcsh ) then
    bindkey "^W" backward-delete-word
    bindkey -k up history-search-backward
    bindkey -k down history-search-forward
    bindkey "\e[1~" beginning-of-line # Home
    bindkey "\e[7~" beginning-of-line # Home rxvt
    bindkey "\e[2~" overwrite-mode    # Ins
    bindkey "\e[3~" delete-char       # Delete
    bindkey "\e[4~" end-of-line       # End
    bindkey "\e[8~" end-of-line       # End rxvt
  endif
endif


onintr -
set noglob

complete pf-sshinvaliduserip	n/{toblacklist}/"(-a)"/ \
								n/*/"(-a block toblacklist)"/

if ( -d /server/savepf ) then
complete pf-anchor-clear	n/*/"(`ls -1 /server/savepf/ | grep anchor | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-anchor-load		n/*/"(`ls -1 /server/savepf/ | grep anchor | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-anchor-save		n/*/"(`ls -1 /server/savepf/ | grep anchor | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-anchor-show		n/*/"(`ls -1 /server/savepf/ | grep anchor | cut -d. -f1 | tr '\n' ' '`)"/

complete pf-table-add		n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-backup	n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-clear		n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-delete	n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-expire	n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-import	n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-load		n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-save		n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
complete pf-table-show		n/*/"(`ls -1 /server/savepf/ | grep table | cut -d. -f1 | tr '\n' ' '`)"/
endif

complete ezjail-admin	n/{list}/"()"/ \
						n/{install}/"(-p -s -h)"/ \
						n/{update}/"(-u -p -s)"/ \
						n/{delete}/"(-w)"/ \
						'n/{start,onestart,delete,archive,-w}/`ezjail-admin list | grep -v "JID.*IP.*Hostname.*Directory" | grep -v "\-\-\-" | awk \$2\~N\{print\ \$4\}`/' \
						'n/{console,stop,onestop}/`jls| grep -v "JID.*IP Address.*Hostname.*Path" | awk \$3\{print\ \$3\}`/' \
						'n/{restore}/`ezjail-admin list | grep -v "JID.*IP.*Hostname.*Directory" | grep -v "\-\-\-" | awk \$4\{print\ \$4\}`/' \
						n/*/"(list console start stop delete archive restore create install update onestart onestop)"/
unset noglob
onintr
source /usr/share/examples/tcsh/complete.tcsh
