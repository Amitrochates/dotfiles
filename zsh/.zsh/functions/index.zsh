docker() {
  if [ "$1" = "kill" ]; then
    shift
    # If a container ID/name is passed, behave normally
    if [ -n "$1" ]; then
      command docker kill "$@"
      return
    fi

    # Otherwise, open fzf selector
    local line cid
    line=$(docker ps --format '{{.ID}} {{.Names}}' \
      | fzf --preview 'docker logs $(echo {} | awk "{print \$1}")') || return

    cid=$(echo "$line" | awk '{print $1}')
    command docker kill "$cid"
  else
    command docker "$@"
  fi
}
git() {

  ########################################
  #              git diff                #
  ########################################
  if [ "$1" = "diff" ]; then
    shift

    # If args provided → run normal diff
    if [ $# -gt 0 ]; then
      command git diff "$@"
      return
    fi

    # No args → fzf diff picker
    local file
    file=$(
    command git diff --name-only |
      fzf --preview "git diff --color=always {} | bat --color=always --paging=never -l diff"
          ) || return

          command git diff "$file"
          return
  fi



  ########################################
  #            git checkout              #
  ########################################
  if [ "$1" = "checkout" ]; then
    shift

    # If args provided → normal checkout
    if [ $# -gt 0 ]; then
      command git checkout "$@"
      return
    fi

    # No args → fzf branch selector (smart mode)
    local branch

    branch=$(
    {
      # Local branches
      git branch --color=always | sed 's/^..//'

        # Remote-only branches (local vs remote diff)
        comm -13 \
          <(git branch --format="%(refname:short)" | sort) \
          <(git branch -r --format="%(refname:short)" \
          | sed 's#origin/##' \
          | grep -v "HEAD ->" \
          | sort)
        } |
          sort -u |
          fzf --ansi \
          --preview "git log --oneline --decorate --graph --color=always {}" \
          --preview-window=right:70%
                  ) || return

    # Strip color codes
    branch=$(echo "$branch" | sed 's/\x1b\[[0-9;]*m//g')

    command git checkout "$branch"
    return
  fi

  ########################################
  #               git log                #
  ########################################
  if [ "$1" = "log" ]; then
    shift

    # If args provided → normal show
    if [ $# -gt 0 ]; then
      command git log "$@"
      return
    fi

    # No args → fzf commit selector
    local commit
    commit=$(
    git log --oneline --decorate --color=always |
      fzf --ansi \
      --preview "git show --color=always {1} | bat --color=always --paging=never -l diff" \
      --preview-window=right:70% \
      --delimiter=' ' \
      --with-nth=1.. \
      --nth=1
          ) || return

    # Extract the commit hash (first token, strip color)
    commit=$(echo "$commit" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')

    command git show "$commit"
    return
  fi
  ########################################
  #              git add                 #
  ########################################
  if [ "$1" = "add" ]; then
    shift
    # If args provided → run normal add
    if [ $# -gt 0 ]; then
      command git add "$@"
      return
    fi
    
    # No args → interactive fzf add/unstage
    echo "" | fzf \
      --ansi \
      --multi \
      --prompt="Git Add > " \
      --header="Tab: multi-select | .: toggle stage/unstage | Enter: finish" \
      --bind='start:reload(
        {
          command git ls-files --others --exclude-standard | sed "s/^/[N] /" | GREP_COLORS="ms=01;31" grep --color=always ".*";
          command git diff --name-only | sed "s/^/[U] /" | GREP_COLORS="ms=01;31" grep --color=always ".*";
          command git diff --cached --name-only | sed "s/^/[S] /" | GREP_COLORS="ms=01;32" grep --color=always ".*"
        } | sort -k2
      )' \
      --bind='.:execute-silent(
        echo {} | while read -r line; do
          st=$(echo "$line" | awk "{print \$1}" | sed "s/\x1b\[[0-9;]*m//g")
          f=$(echo "$line" | awk "{print \$2}")
          if [ "$st" = "[S]" ]; then
            command git reset HEAD "$f" 2>/dev/null
          else
            command git add "$f" 2>/dev/null
          fi
        done
      )+reload(
        {
          command git ls-files --others --exclude-standard | sed "s/^/[N] /" | GREP_COLORS="ms=01;31" grep --color=always ".*";
          command git diff --name-only | sed "s/^/[U] /" | GREP_COLORS="ms=01;31" grep --color=always ".*";
          command git diff --cached --name-only | sed "s/^/[S] /" | GREP_COLORS="ms=01;32" grep --color=always ".*"
        } | sort -k2
      )' \
      --preview='
        line={}
        st=$(echo "$line" | awk "{print \$1}" | sed "s/\x1b\[[0-9;]*m//g")
        f=$(echo "$line" | awk "{print \$2}")
        if [ "$st" = "[S]" ]; then
          command git diff --cached --color=always "$f" | bat --color=always --paging=never -l diff 2>/dev/null || echo "Staged: $f"
        elif [ "$st" = "[N]" ]; then
          bat --color=always --paging=never "$f" 2>/dev/null || echo "New file: $f"
        else
          command git diff --color=always "$f" | bat --color=always --paging=never -l diff 2>/dev/null || echo "Modified: $f"
        fi
      '
    
    return
  fi 
  ########################################
  #          fallback → real git         #
  ########################################
  command git "$@"
}

