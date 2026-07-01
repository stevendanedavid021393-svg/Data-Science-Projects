# Note: FRED now requires a free API key for reliable access (it didn't when
# this tutorial was written). If getSymbols() below fails with "Unable to
# import CPIAUCNS", register a key at https://fredaccount.stlouisfed.org/apikeys
# and uncomment the setDefaults() line before sourcing this file:
# quantmod::setDefaults(getSymbols.FRED, api.key = "your key")
if (!exists(".inflation")) {
  .inflation <- getSymbols('CPIAUCNS', src = 'FRED',
     auto.assign = FALSE)
}

# adjusts Google finance data with the monthly consumer price index 
# values provided by the Federal Reserve of St. Louis
# historical prices are returned in present values 
adjust <- function(data) {

      latestcpi <- last(.inflation)[[1]]
      inf.latest <- time(last(.inflation))
      months <- split(data)               
      
      adjust_month <- function(month) {               
        date <- substr(min(time(month[1]), inf.latest), 1, 7)
        coredata(month) * latestcpi / .inflation[date][[1]]
      }
      
      adjs <- lapply(months, adjust_month)
      adj <- do.call("rbind", adjs)
      axts <- xts(adj, order.by = time(data))
      axts[ , 5] <- Vo(data)
      axts
}