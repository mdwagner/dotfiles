switch (uname)
  case Linux
    # ssh
    set -x SSH_AUTH_SOCK $HOME/.ssh/agent.sock
    ss -a | grep -q $SSH_AUTH_SOCK
    if [ $status != 0 ]
      rm -f $SSH_AUTH_SOCK
      setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe >/dev/null 2>&1 &
    end
    # asdf-vm
    source ~/.asdf/asdf.fish
    set -g fish_user_paths $HOME"/.local/bin" $fish_user_paths
  case Darwin
    # asdf-vm
    source (brew --prefix asdf)"/libexec/asdf.fish"
    # paths
    set -g fish_user_paths (brew --prefix node@14)"/bin" $fish_user_paths
    set -g fish_user_paths (brew --prefix ruby@2.6)"/bin" $fish_user_paths
end
