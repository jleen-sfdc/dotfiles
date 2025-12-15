$XONSH_SHOW_TRACEBACK = False
$TITLE = '{cwd}'

xontrib load coreutils
xontrib load prompt_starship

def v(args):
    for arg in args:
        $SV_NEOVIDE_BIN --wsl -- @(arg) &

aliases['v'] = v
