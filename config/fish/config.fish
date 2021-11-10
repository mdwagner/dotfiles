switch (uname)
  case Linux
    source ~/.asdf/asdf.fish
  case Darwin
    source (brew --prefix asdf)"/libexec/asdf.fish"
    set -g fish_user_paths (brew --prefix node@14)"/bin" $fish_user_paths
    set -g fish_user_paths (brew --prefix ruby@2.6)"/bin" $fish_user_paths
end
