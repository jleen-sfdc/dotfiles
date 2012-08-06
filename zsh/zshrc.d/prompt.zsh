# Saturn Valley Intergalactic Standard Command Prompt

typeset -ga precmd_functions
typeset -ga chpwd_functions
typeset -ga preexec_functions

function set_git_prompt {
  gitref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $gitref ]] ; then
    gitbranch="[${gitref#refs/heads/}]"
  else
    gitbranch=""
  fi
  RPROMPT="${gitbranch}"
}

function zsh_git_prompt_precmd {
  if [[ -n "$PR_GIT_UPDATE" ]] ; then
    set_git_prompt
    PR_GIT_UPDATE=
  fi
}
precmd_functions+='zsh_git_prompt_precmd'

function zsh_git_prompt_chpwd {
  PR_GIT_UPDATE=1
}
chpwd_functions+='zsh_git_prompt_chpwd'

function zsh_git_prompt_preexec {
  case "$(history $HISTCMD)" in 
  *git*)
    PR_GIT_UPDATE=1
    ;;
  esac
}
preexec_functions+='zsh_git_prompt_preexec'

PR_GIT_UPDATE=1

# TODO(jleen): I should be able to do "function {" and get an anonymous scope
# that's executed immediately.  Maybe it only works on versions > 4.3.4, which
# is what Leopard gives me?
setprompt () {
  [ -n "$HOST" ] && host="$HOST" || host=`uname -n`
  local short_host=`echo ${host}|cut -d. -f1`
  if [ "$TERM" = "dumb" ]; then
    # We're probably in Emacs M-x shell.
    PROMPT='${short_host} [%~]%# '
  else
    if [ -n "$WINDOW" ]; then
      local screen=":$WINDOW"
      local screen_clear="`print \\\\ek\\\\e\\\\134`"
    fi
    if [[ $TERM = (xterm*|rxvt*|screen|cygwin) ]]; then
      local xterm="`print \\\\e`]0;$SHELLPREFIX${short_host}${screen}:%~`print \\\\007`"
    fi
    if [ -n "$SHELLPREFIX" ]; then
      local prefix="%{`tput setaf 0``tput bold`%}$SHELLPREFIX%{`tput sgr0`%}"
    fi
    local cruft="%{${screen_clear}${xterm}${shellprefix}%}"
    local color_on="%{`tput setaf ${SHELLCOLOR:-4}``tput bold`%}"
    local color_off="%{`tput sgr0`%}"
    setopt prompt_subst
    PROMPT="${cruft}${prefix}${color_on}${short_host}${screen}${color_off} [\${SV_PWD_PROMPT:-%~}]%# "
  fi
}
setprompt
unfunction setprompt