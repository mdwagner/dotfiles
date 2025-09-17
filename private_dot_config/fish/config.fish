if type -sq fish
  set -gx SHELL (type -P fish)
end

if type -sq vi
  set -gx EDITOR (type -P vi)
else if type -sq vim
  set -gx EDITOR (type -P vim)
end

if type -sq nvim
  set -gx GIT_EDITOR (type -P nvim)
end

mkdir -p ~/.local/bin
fish_add_path ~/.local/bin

if type -sq mise
  if status is-interactive
    mise activate fish | source
  else
    mise activate fish --shims | source
  end
end

if test -S ~/.1password/agent.sock
  set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
end

if type -sq op
  op completion fish | source
end
