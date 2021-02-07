$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
Remove-Item imdb.txt -ErrorAction Ignore

function SyncLists {
#2021
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2021-01-01,2021-12-31&user_rating=6.0,&num_votes=10000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2021" "Releases=Releases" "NoReleases=No Releases"'

#2020
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2020-01-01,2020-12-31&user_rating=6.0,&num_votes=10000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2020" "Releases=Releases" "NoReleases=No Releases"'

#2019
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2019-01-01,2019-12-31&user_rating=6.0,&num_votes=30000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2019" "Releases=Releases" "NoReleases=No Releases"'

#2018
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2018-01-01,2018-12-31&user_rating=6.0,&num_votes=30000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2018" "Releases=Releases" "NoReleases=No Releases"'

#2017
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2017-01-01,2017-12-31&user_rating=6.0,&num_votes=30000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2017" "Releases=Releases" "NoReleases=No Releases"'

#2016
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2016-01-01,2016-12-31&user_rating=6.0,&num_votes=30000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2016" "Releases=Releases" "NoReleases=No Releases"'

#2015
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2015-01-01,2015-12-31&user_rating=6.0,&num_votes=30000,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=2015" "Releases=Releases" "NoReleases=No Releases"'

#Horror
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2015-01-01,&user_rating=5.5,&num_votes=10000,&genres=horror,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=Horror" "Releases=DONT_MODIFY" "NoReleases=DONT_MODIFY"'

#Turkish
$r=Invoke-WebRequest -Uri 'https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&release_date=2015-01-01,&user_rating=5.5,&num_votes=3000,&countries=tr,&count=250&view=simple'
$r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique > imdb.txt
iex 'flexget execute -v  --no-cache --cli-config "ListName=Turkish" "Releases=DONT_MODIFY" "NoReleases=DONT_MODIFY"'
}

SyncLists | Tee-Object -file log.txt

pause




