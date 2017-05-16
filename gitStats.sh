#!/bin/bash


OPTIND=1         # Reset in case getopts has been used previously in the shell.
ROOT_DIRECTORY=$1


#Total nloc   Avg.NLOC  AvgCCN  Avg.token   Fun Cnt  Warning cnt   Fun Rt   nloc Rt
#------------------------------------------------------------------------------------------
#       738   8.0        1.1       51.9       37            0      0.00    0.00
# This method pretty outputs the last line

function lizardStatsForFile {
    output="$(python /Users/xxxxx/Downloads/lizard-master/lizard.py "$1")"
    lastline="${output##*$'\n'}"
    IFS=':'; arrIN=($lastline); unset IFS;
    echo $arrIN
}


function numberOfCommitsForFile {
    commitForFile="$(git log --pretty=format:"%h" --follow "$1" | wc -l)"
    IFS=':'; arrIN=($commitForFile); unset IFS;
    echo $arrIN
}


function numberOfAuthorsForFile {
    authorsForFile="$(git log --format="%an" --follow "$1" | sort -u | wc -l)"
    IFS=':'; arrIN=($authorsForFile); unset IFS;
    echo $arrIN
}

function numberOfLinesForFile {
    numberOfLines="$(wc -l < "$1")"
    noWhiteSpaces="$(echo -e "${numberOfLines}" | tr -d '[:space:]')"
    echo $noWhiteSpaces
}


function numberOfDaysSinceLastAndFirstCommitForFile {
    # multi line output of date and folder, will include extra dates if folder name changed

    gitLogsFileAdded="$(git log --format="format:%ci" --follow "$1")"

    oldIFS="$IFS"
    IFS='
    '
    IFS=${IFS:0:1}
    lines=( $gitLogsFileAdded )
    IFS="$oldIFS"

    if [ ${#lines[@]} -eq 0 ]; then
    echo "0 0"
    else
    numberOfLines=${#lines[@]}

    timeOfLastCommit=${lines[0]}
    timeOfFirstCommit=${lines[$numberOfLines-1]}

    lastCommitDateSeconds=$(date -j -f '%Y-%m-%d %H:%M:%S %z' "$timeOfLastCommit" +'%s')
    firstCommitDateSeconds=$(date -j -f '%Y-%m-%d %H:%M:%S %z' "$timeOfFirstCommit" +'%s')

    todaysDateSeconds=$(date +'%s')
    periodOfDays=$((60*60*24))

    dateDiffLastCommit=$(( ($todaysDateSeconds - $lastCommitDateSeconds)/($periodOfDays) ))
    dateDiffFirstCommit=$(( ($todaysDateSeconds - $firstCommitDateSeconds)/($periodOfDays) ))

    echo "${dateDiffLastCommit} ${dateDiffFirstCommit}"
    fi
}


function statsForFile {
    ageOfFirstAndLastCommitFileInDays="$(numberOfDaysSinceLastAndFirstCommitForFile "$1")"
    numberOfCommits="$(numberOfCommitsForFile "$1")"
    numberOfAuthors="$(numberOfAuthorsForFile "$1")"
    numberOfLines="$(numberOfLinesForFile "$1")"
    lizardStats="$(lizardStatsForFile "$1")"
    echo "${ageOfFirstAndLastCommitFileInDays} ${numberOfCommits} ${numberOfAuthors} ${numberOfLines} ${lizardStats} $2 $file"
}


function echoNumberOfTotalCommitsForRepo {
    echo "number of total commits for repo $(git rev-list --all --count)"
}


function echoNumberOfContributorsForRepo {
    numberOfContributors=$(git log --format='%aN' | sort -u | wc -l)
    noWhiteSpaces="$(echo -e ${numberOfContributors} | tr -d '[:space:]')"
    echo "number of total contributors for repo ${noWhiteSpaces}"
}

function echoNumberOfContributorsWeeksAgo {
    numberOfContributors=$(git shortlog -sn --since "$1 weeks ago" --until "$2 weeks ago" | sort -u | wc -l)
    noWhiteSpaces="$(echo -e ${numberOfContributors} | tr -d '[:space:]')"
    echo "number of contributors for $3 $noWhiteSpaces"
}


# Ensure user has entered the folder to examin

if [ -z "${ROOT_DIRECTORY}" ]
then
echo "1st argument to the script is the root folder location which has not been added, using current folder "
ROOT_DIRECTORY="$(pwd)"
fi

echo "Please make sure you have set the directory for lizard in the method lizardStatsForFile"
echo "Looking in root directory ${ROOT_DIRECTORY} and sub folders"

# Echo repo stats

echoNumberOfTotalCommitsForRepo
echoNumberOfContributorsForRepo
echoNumberOfContributorsWeeksAgo "4" "1" "this month"
echoNumberOfContributorsWeeksAgo "24" "20" "6 months ago"
echoNumberOfContributorsWeeksAgo "52" "48" "1 year ago"
echoNumberOfContributorsWeeksAgo "76" "72" "1.5 years ago"
echoNumberOfContributorsWeeksAgo "104" "100" "2 years ago"
echoNumberOfContributorsWeeksAgo "156" "152" "3 years ago"
echoNumberOfContributorsWeeksAgo "208" "204" "4 years ago"
echoNumberOfContributorsWeeksAgo "260" "266" "5 years ago"
echoNumberOfContributorsWeeksAgo "312" "308" "6 years ago"


## Echo file stats

echo "days since last commit, days since first commit, nCommits, nAuthors, nLines, nloc, Avg.NLOC , AvgCCN,  Avg.token, Fun Cnt, Warning cnt, Fun Rt, nloc Rt, Test(Yes=1)"

FOLDER=${ROOT_DIRECTORY}

find "${FOLDER}" -type f -name '*.m' -or -name '*.swift' | while read file; do

    if [[ $file == *"Test"* ]]; then
    statsForFile "$file" "1"
    else
    statsForFile "$file" "0"
    fi
done
