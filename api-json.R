#httr
#jsonlite

urlapi <- "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2020-02-22&endtime=2020-02-24"

getreq <- httr::GET(urlapi)

getcontent <- httr::content(getreq,"text")

datajs <- jsonlite::fromJSON(getcontent,flatten = TRUE)

dfgempa <- datajs$features
