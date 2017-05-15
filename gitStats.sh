#!/bin/bash


OPTIND=1         # Reset in case getopts has been used previously in the shell.
ROOT_DIRECTORY=$1


#Total nloc   Avg.NLOC  AvgCCN  Avg.token   Fun Cnt  Warning cnt   Fun Rt   nloc Rt
#------------------------------------------------------------------------------------------
#       738   8.0        1.1       51.9       37            0      0.00    0.00
# This method pretty outputs the last line

function lizardStatsForFile {
    output="$(python /Users/xxxx/Downloads/lizard-master/lizard.py "$1")"
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
    echo "$(wc -l < "$1")"
}


function numberOfDaysOldForFile {
    # multi line output of date and folder, will include extra dates if folder name changed
    gitLogsFileAdded="$(git log --format="format:%ci" --name-only --diff-filter=A --follow "$1")"

    oldIFS="$IFS"
    IFS='
    '
    IFS=${IFS:0:1}
    lines=( $gitLogsFileAdded )
    IFS="$oldIFS"
    numberOfLines=${#lines[@]}
    secondToLastLine=${lines[$numberOfLines-2]}
    fileAddedDateSeconds=$(date -j -f '%Y-%m-%d %H:%M:%S %z' "$secondToLastLine" +'%s')
    todaysDateSeconds=$(date +'%s')
    periodOfDays=$((60*60*24))
    datediff=$(( ($todaysDateSeconds - $fileAddedDateSeconds)/($periodOfDays) ))
    echo $datediff
}


function statsForFile {
    ageOfFileInDays="$(numberOfDaysOldForFile $1)"
    numberOfCommits="$(numberOfCommitsForFile $1)"
    numberOfAuthors="$(numberOfAuthorsForFile $1)"
    numberOfLines="$(numberOfLinesForFile $1)"
    lizardStats="$(lizardStatsForFile "$1")"
    echo "${ageOfFileInDays} ${numberOfCommits} ${numberOfAuthors} ${lizardStats} $2"
}


function echoNumberOfTotalCommitsForRepo {
    echo "number of total commits for repo $(git rev-list --all --count)"
}


function echoNumberOfContributorsForRepo {
    echo "number of contributors for repo $(git log --format='%aN' | sort -u | wc -l)"
}


# Ensure user has entered the folder to examin

# Ensure user has entered the folder to examin

if [ -z "${ROOT_DIRECTORY}" ]
then
echo "1st argument to the script is the root folder location which has not been added, using current folder "
ROOT_DIRECTORY="$(pwd)"
echo ${ROOT_DIRECTORY}
fi

echo "Please make sure you have set the directory for lizard in the method lizardStatsForFile"
echo "Looking in root directory ${ROOT_DIRECTORY} and sub folders"

# Echo repo stats

echoNumberOfTotalCommitsForRepo
echoNumberOfContributorsForRepo

# Echo file stats

files="$(find -L "$ROOT_DIRECTORY" -type f -name '*.m' -or -name '*.swift')"
echo "Count: $(echo -n "$files" | wc -l)"
echo "age days, nCommits, nAuthors, nLines nloc, Avg.NLOC , AvgCCN,  Avg.token, Fun Cnt, Warning cnt, Fun Rt, nloc Rt, Test(Yes=1)"

echo "$files" | while read file; do

    if [[ $file == *"Test"* ]]; then
        statsForFile $file "1"
    else
        statsForFile $file "0"
    fi
done
