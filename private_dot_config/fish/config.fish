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

if test -f ~/.config/fish/platform_config.fish
  source ~/.config/fish/platform_config.fish
end
