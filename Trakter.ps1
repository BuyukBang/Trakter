$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
Remove-Item imdb.txt -ErrorAction Ignore


function DoJobs {
  $SixMonthsAgo=(Get-Date).AddMonths(-6).ToString('yyyy-MM-dd')
  $UrlParams='release_date=' + $SixMonthsAgo + ',&user_rating=6.0,&num_votes=10000,'
  UpdateList '"Releases=Releases" "NoReleases=No Releases"' $UrlParams
  UpdateList '"Releases=Releases" "NoReleases=No Releases"' 'release_date=2015,&user_rating=6.0,&num_votes=25000,'
  UpdateList '"Releases=Releases With Low Rating" "NoReleases=No Releases With Low Rating"' 'release_date=2015,&user_rating=5.0,5.9&num_votes=25000,'
  UpdateList '"Releases=Horror Releases" "NoReleases=Horror No Releases"' 'release_date=2015,&user_rating=5.3,&num_votes=10000,&genres=horror,'
  UpdateList '"Releases=Turkish Releases" "NoReleases=Turkish No Releases"' 'release_date=2015,&user_rating=5.3,&num_votes=3000,&countries=tr,'
}


function UpdateList() {
	$FlexgetParams=$args[0]
	$UrlParams=$args[1]
	echo "Starting update for --> $FlexgetParams $UrlParams"

	#Clean up	
	Remove-Item imdb.txt -ErrorAction Ignore
  iex 'flexget database reset-plugin discover'
  iex 'flexget movie-list purge All'
  iex 'flexget movie-list purge Releases'
  iex 'flexget movie-list purge NoReleases'
  iex 'flexget movie-list purge ReleasesWithPossibleDuplicates'

	#Download IMDB List
	$MovieCount=0
	$MovieCountPrevious=-1
	$StartValue=0
	#Comparing with a high value to be sure about infinite loops on error cases
	while(($MovieCount -gt $MovieCountPrevious) -and ($MovieCount -lt 2000) -and ($MovieCount%250 -eq 0)) 
  {
  	echo "Getting movie list from IMDB at $StartValue for --> $FlexgetParams"
  	$MovieCountPrevious=$MovieCount
	  $Url='https://www.imdb.com/search/title/?title_type=feature,tv_movie,documentary,short,video&view=simple&count=250&start=' + $StartValue + '&' + $UrlParams
    $r=Invoke-WebRequest -Uri $Url
    $r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique >> imdb.txt
    $MovieCount=(Get-Content -ErrorAction Ignore imdb.txt).Length
    $StartValue=$StartValue+250
    Start-Sleep -s 1
  }
  echo "$MovieCount movies found at IMDB for --> $FlexgetParams"
  
  #Execute FlexGet
  $cmd='flexget execute -v --no-cache --discover-now --cli-config ' + $FlexgetParams
  iex $cmd
  
	echo "Completed update for --> $FlexgetParams $UrlParams"
}


DoJobs | Tee-Object -file log.txt




