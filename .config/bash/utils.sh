# Just a proxy for pbcopy, used so that we can eventually
# be cross-platform.
function system_copy {
  pbcopy "$@"
}

# Just a proxy for pbpaste, used so that we can eventually
# be cross-platform.
function system_paste {
  pbpaste "$@"
}

# Strip newslines from the input.
# Returns a single string
function strip_newlines {
  printf "%s" `echo "$@" | sed -e :a -e N -e '$!ba' -e 's/\n//g'`
}

function ScriptDir {
  echo "$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

# Add the utilities in the utils/ directory to the path.
export PATH=$PATH:$(ScriptDir)/utils

function killport {
  kill -9 $(lsof -ti tcp:$1)
}

function searchport {
  lsof -i tcp:$1
}

function gitBranchName {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function recentBranches {
  git branch --sort=committerdate
}

function lastBranch {
  currentBranchName=$(gitBranchName)
  mostRecentBranch=$(git branch --sort=committerdate | grep -v $currentBranchName | tail -n 1)
  git checkout ${mostRecentBranch}
}

function debug_print_colors {
  awk 'BEGIN{
      s="/\\/\\/\\/\\/\\"; s=s s s s s s s s s s s s s s s s s s s s s s s;
      for (colnum = 0; colnum<256; colnum++) {
          r = 255-(colnum*255/255);
          g = (colnum*510/255);
          b = (colnum*255/255);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum+1,1);
      }
      printf "\n";
  }'
}
