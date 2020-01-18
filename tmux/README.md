# Usage tmux cmd
## window
```
Ctrl-b c : 새창을 생성합니다.
Ctrl-b d : 현재 클라이언트에서 떨어집니다.
Ctrl-b l : 이전에 선택한 윈도우로 이동합니다.
Ctrl-b n : 다음 윈도우로 이동합니다.
Ctrl-b p : 이전 윈도우로 이동합니다.
Ctrl-b w : 윈도우의 리스트를 보여주고 번호를 입력하면 이동합니다.
Ctrl-b 윈도우번호 : 해당 윈도우로 이동합니다.
Ctrl-b & : 현재 윈도우를 종료합니다.
Ctrl-b , : 현재 윈도우의 이름을 바꿉니다.
```

## pane
```
Ctrl-b % : 세로로 2개의 팬으로 나눕니다.
Ctrl-b " : 가로로 2개의 팬으로 나눕니다.
Ctrl-b q : 팬 번호를 보여준다.(팬사이를 이동하는데 사용된다.)
Ctrl-b o : 다음 팬으로 이동합니다.
Ctrl-b { : 왼쪽 팬으로 이동합니다.
Ctrl-b } : 왼쪽 팬으로 이동합니다.
Ctrl-b 방향키 : 방향키 위치의 팬으로 이동합니다.
Ctrl-b <alt>-방향키 : 현재 팬의 사이즈를 조정합니다.
```

## tmux.conf
### Set status bar
```
set -g status-bg black
set -g status-fg white
set -g status-left '#[fg=green]#H'
```

## Highlight active window
```
set-window-option -g window-status-current-bg red
```

## modify status bar
```
set -g status-right ‘#[fg=yellow]#(uptime | cut -d “,” -f 2-)’
```

## tmux login shell
```
tmux new-session -s $(env | egrep "^LC_TERMINAL=" | cut -d "=" -f2)-$(env | grep  ITERM_SESSION_ID | awk 'BEGIN{FS="-"} {print $NF}')
```

