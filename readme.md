## About

We all know that we should all be writing simpler code, but what really makes code complicated and is there any real need to address it.  So it first makes sense to prove there is a problem or at least recognise when we should be thinking about it.  For this I’ve created a script that will extract annonoumous git and file stats from Xcode projects, such as age of file, number of commits, CCN value etc.  
If you are kind enough to send me the stats I can use them in a series of blog posts about code complexity on when we should address the issue and how we can go out it.

## Requirements

- Mac
- Lizard
- Xcode git repo project

## Installation

1. First install Lizzard, you can find it here https://github.com/terryyin/lizard.  I just downloaded the repo and placed it into my Downloads folder.
2. Download the gitStats.sh script in this repo and place it into the folder that contains the Xcode git repo you want to inspect, usually the root of your project.
3. Amend the script method 'lizardStatsForFile' to point to the location of lizard.py, so if you downloaded it to Users/bob/Downloads/ the method should look something like the following... (please excuse my terrible bash scripting skills)

```
function lizardStatsForFile {
    output="$(python /Users/bob/Downloads/lizard-master/lizard.py "$1")"
    lastline="${output##*$'\n'}"
    IFS=':'; arrIN=($lastline); unset IFS;
    echo $arrIN
}
```

4. Run the script and wait a little while (the more files there are the longer this takes)

```
bash gitStats.sh "/location/of/project/folders" > output.txt
```

Note: If you want to see which file the stats relate to amend the following line

from
```
echo "${ageOfFileInDays} ${numberOfCommits} ${numberOfAuthors} ${lizardStats} $2"
```
to
```
echo "${ageOfFileInDays} ${numberOfCommits} ${numberOfAuthors} ${lizardStats} $2 $file"
```


## Script Output:

### Information per repo

Number of commits
Number of contributors

### Information per file
```
num days old
num of commits 
num of authors
lizzard stats - nLines, nLoc, Avg.NLOC, AvgCCN, Avg.token, Fun Cnt, Warning Cnt, Fun Rt, nLoc RT
Is test file
```
### Example

```
number of total commits for repo 34683
number of contributors for repo 79
Count: 470
age days, nCommits, nAuthors, nLines nloc, Avg.NLOC , AvgCCN,  Avg.token, Fun Cnt, Warning cnt, Fun Rt, nloc Rt, Test(Yes=1)
813 496 12 21 9.5 2.0 43.0 2 0 0.00 0.00 0 0
1204 500 16 221 7.7 2.0 38.6 26 0 0.00 0.00 0 0
813 497 12 101 9.0 1.4 42.6 11 0 0.00 0.00 0 1
1295 506 15 120 35.0 9.3 259.7 3 1 0.33 0.63 0 0
813 500 15 30 5.4 1.0 30.8 5 0 0.00 0.00 0 0
813 514 15 227 6.9 1.7 34.7 27 0 0.00 0.00 0 0
1603 514 18 147 20.6 5.6 161.0 7 0 0.00 0.00 0 0
1603 495 13 8 0.0 0.0 0.0 1 0 0.00 0.00 0 0
1141 516 15 30 4.8 1.5 19.8 4 0 0.00 0.00 0 0
813 494 14 17 4.0 1.0 19.0 4 0 0.00 0.00 0 0
813 507 12 77 11.7 2.3 46.2 6 0 0.00 0.00 0 0
813 497 13 72 11.6 1.2 92.6 5 0 0.00 0.00 1 0
813 611 27 356 8.5 1.8 44.8 34 0 0.00 0.00 0 0
```

## Sharing

The more we share the more we learn.  

I'd love to get access to your project stats and compare them to others, but I'll only make it annonoumously public on your request, e.g it will be held in this repo under a folder called ProjectA etc.

Please see below the instruction for sharing the data and if you could also include the following questions and answers that would be amazing.


## Emailing

```
Email Address:   xxxx
Subject: Project Stats v1
Body:

You can only share the stats annonoumously in this repo [YES/NO]
The software architecture used in this project is [MCV with some MVVM, just Reactive etc]
The average number of developers today is [x]
The average number of QA today is [x]
The team is still growing [YES/NO]
The project is still under development [YES/NO]
We have specific written down coding standards [YES/NO]
We have specific OCLint rules [max method lines 15 etc, no more than 20 methods to a class etc]
We write tests [SOME TIMES / ALL OF THE TIME]
Our style of testing is [UNIT + ACCEPTANCE / just BDD]
We use A/B testing [YES/NO] 
We practice TTD [YES/NO]

(I appreciated you may not want to answer the following, but it does not hurt to ask)
Either
The average percentage of daily crashes against number of users is [x], you can use this publically and anonymously [YES/NO]
Or
Average number of daily users [x], you can use this publically and anonymously [YES/NO]
Average number of daily crashes [x], you can use this publically and anonymously [YES/NO]
```

