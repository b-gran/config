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
