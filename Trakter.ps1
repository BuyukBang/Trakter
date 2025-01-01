$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
Remove-Item imdb.txt -ErrorAction Ignore

function DoJobs {
  $SixMonthsAgo=(Get-Date).AddMonths(-6).ToString('yyyy-MM-dd')
  $UrlParams='release_date=' + $SixMonthsAgo + ',&user_rating=6.0,&num_votes=10000,&country_of_origin=!in,&primary_language=!hi'
  UpdateList '"Releases=Releases"' add 0 0 $UrlParams
  UpdateList '"Releases=Releases"' add 2023 0 '&user_rating=5.0,&num_votes=25000'
  $UrlParams='release_date=2,&user_rating=6.0,&num_votes=10000,80000,&country_of_origin=!in,&primary_language=!hi'
  UpdateList '"Releases=Releases"' remove 0 0 $UrlParams
  UpdateList '"Releases=Releases 2020-2022"' add 2020 2022 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Releases 2016-2019"' add 2016 2019 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Releases 2012-2015"' add 2012 2015 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Releases 2009-2011"' add 2009 2011 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Releases 2005-2008"' add 2005 2008 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Releases 2000-2004"' add 2000 2004 '&user_rating=5.0,&num_votes=25000'
  UpdateList '"Releases=Horror Releases"' add 2013 0 '&genres=horror&user_rating=5.0,&num_votes=10000'
  UpdateList '"Releases=Turkish Releases"' add 2013 0 '&countries=tr&user_rating=5.0,&num_votes=3000'
}

function UpdateList() {
  $FlexgetParams=$args[0]
  $Operation=$args[1]
  $StartYear=$args[2]
  $EndYear=$args[3]
  $UrlParams=$args[4]
  if ($EndYear -eq "0") {
  	$EndYear=(Get-Date).ToString('yyyy')
  }
  echo "Starting update for --> $StartYear $EndYear $UrlParams"

  #Clean up
  Remove-Item imdb.txt -ErrorAction Ignore
  iex 'flexget database reset-plugin discover'
  iex 'flexget movie-list purge Releases'
  iex 'flexget movie-list purge New'
  #iex 'flexget movie-list purge All'
  #iex 'flexget movie-list purge NoReleases'
  #iex 'flexget movie-list purge ReleasesWithPossibleDuplicates'

  #Download IMDB List
  while(($StartYear -eq "0") -or ($StartYear -le $EndYear))
  {
    echo "Getting movie list from IMDB at $StartValue for --> $FlexgetParams"
    $Url=""
    if ($StartYear -eq "0") {
    	$Url='https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,short,video&count=250&' + $UrlParams
    } else {
    	$Url='https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,short,video&count=250&release_date=' + $StartYear + ',' + $StartYear + $UrlParams
    }
    echo $Url
    $r=Invoke-WebRequest -Uri $Url
    $r.content.split("`r`n") | select-string -Pattern 'tt\d{7,8}' -AllMatches | foreach {$_.matches.value} | sort | get-unique >> imdb.txt
    if ($StartYear -eq "0") {
        break
    }
    $StartYear=$StartYear+1
    Start-Sleep -s 1
  }
  $MovieCount=(Get-Content -ErrorAction Ignore imdb.txt).Length
  echo "$MovieCount movies found at IMDB for --> $FlexgetParams"
  
  #Execute FlexGet
  $cmd=""
  if ($Operation -eq "add") {
  	$cmd='flexget execute -v --no-cache --cli-config ' + $FlexgetParams
  } elseif ($Operation -eq "remove") {
  	$cmd='flexget -c remove.yml execute -v --no-cache --cli-config ' + $FlexgetParams
	}
  iex $cmd
  
  echo "Completed update for --> $FlexgetParams $UrlParams"
}

DoJobs | Tee-Object -file log.txt




