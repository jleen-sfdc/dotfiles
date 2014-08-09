# Saturn Valley Pandimensional Uniform Editor Launcher

if [[ $SVPLATFORM = cygwin ]]; then
  v () {
    if [[ $#* -gt 3 ]]; then
      if [[ $1 == -f ]]; then
        shift
      else
        echo 'Specify -f to edit lots of files at once.'
        return 1
      fi
    fi
    if [[ -z $* ]]; then
      cygstart --hide gvim.bat
    else
      for fn in $@; do
        local winfn="`cygpath -wa "$fn"`"
        cygstart --hide gvim.bat "\"$winfn\""
      done
    fi
  }
  alias vv='gvim.bat -R -'
elif [[ $SVPLATFORM = osx ]]; then
  v () {
    if [[ $#* -gt 3 ]]; then
      if [[ $1 == -f ]]; then
        shift
      else
        echo 'Specify -f to edit lots of files at once.'
        return 1
      fi
    fi
    if [[ -z $* ]]; then
      mvim
    else
      for fn in $@; do
        mvim $fn
      done
    fi
  }
  alias vv='mvim -R - > /dev/null'
else
  v () {
    if [[ $#* -gt 3 ]]; then
      if [[ $1 == -f ]]; then
        shift
      else
        echo 'Specify -f to edit lots of files at once.'
        return 1
      fi
    fi
    if [[ $SVPLATFORM = X11 ]]; then
      if [[ -z $* ]]; then
        gvim
      else
        for fn in $@; do
          gvim $fn
        done
      fi
    elif [[ $SVPLATFORM = screen ]]; then
      if [[ -z $* ]]; then
        screen -t vi vi
      else
        for fn in $@; do
          screen -t "vi $fn" vi $fn
        done
      fi
    else
      vi $@
    fi
  }
  vv () {
    if [[ $SVPLATFORM = X11 ]]; then
      gvim -R -
    else
      vi -R -
    fi
  }
fi
