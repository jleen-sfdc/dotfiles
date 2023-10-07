# Saturn Valley Pandimensional Uniform Editor Launcher

if [[ $SV_NEOVIDE_BIN ]]; then
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
      spawn "$SV_NEOVIDE_BIN" --wsl
    else
      for fn in $@; do
        spawn "$SV_NEOVIDE_BIN" --wsl "\"$fn\""
      done
    fi
  }
  alias vv='nvim -R -'
elif [[ $SVLINUX = wsl ]]; then
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
      spawn "${SV_GVIM_EXE:-gvim.exe}"
    else
      for fn in $@; do
        fn=`wslpath -wa $fn`
        spawn "${SV_GVIM_EXE:-gvim.exe}" "$fn"
      done
    fi
  }
  alias vv='spawn "${SV_GVIM_EXE:-gvim.exe}" -R -'
  alias vvv='spawn "${SV_GVIM_EXE:-gvim.exe}"'
elif [[ $svplatform = cygwin ]]; then
  v () {
    if [[ $#* -gt 3 ]]; then
      if [[ $1 == -f ]]; then
        shift
      else
        echo 'specify -f to edit lots of files at once.'
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
  alias vvv='givm.bat'
elif [[ $SVPLATFORM = osx ]]; then
  local macvim_dir=/Applications/MacVim.app/Contents/bin
  [[ -d $macvim_dir ]] && path+=$macvim_dir

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
      local groggy sleeping
      pgrep -qx MacVim || groggy=1
      for fn in $@; do
        [[ -n $sleeping ]] && sleep 0.3 && unset sleeping
        mvim $fn
        [[ -n $groggy ]] && sleeping=1 && unset groggy
      done
    fi
  }
  alias vv='mvim -R - > /dev/null'
  alias vvv='mvim -R'
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
  # Check SVPLATFORM at invocation time, to support screen reattach.
  vv () {
    if [[ $SVPLATFORM = X11 ]]; then
      gvim -R -
    else
      vi -R -
    fi
  }
  vvv () {
    if [[ $SVPLATFORM = X11 ]]; then
      gvim
    else
      vi
    fi
  }
fi
