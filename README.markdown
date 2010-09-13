# Sparklines by Vincent Chu (Aug, 2010)

My sparkline code is a very simple class for generating sparklines using Google's Chart API. I won't say more about sparklines -- already a very good introduction to them on [Edward Tufte's site.](http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR).

My code generates sparklines from incoming data by:

* Resampling the data -- this ensures that you don't cram too much data into the physical rendering of the Sparkline
    * Currently set via MIN_DELTA constant
* Adjusting the data so that the average slope is roughly 1 (or 45 deg) --- ideal, according to Tufte's research
* Normalizing the data to conform to Google's Chart API

There are also many other good packages for generating Sparklines -- mine is certainly not the first, nor is it the best. 

# Usage 

    data = 1000.times.inject([]) { |m, k| m << rand }
    sparkline = Sparkline.new( data, :height => 100, :width => 500 )
    puts sparkline.google_img_url
    # => "http://chart.apis.google.com/chart?chxt=r,x,y&chd=t:41.5,34.3,63.4,45.0,50.5,35.7,40.6,54.9,62.0,60.6,53.2,44.9,62.4,61.8,53.5,58.5,60.4,64.6,64.5,49.8,49.3,61.4,46.4,50.8,36.1,46.5,52.8,39.7,44.4,42.3,57.6,45.6,34.1,49.0,64.1,61.4,59.9,34.0,43.9,44.8,40.4,34.0,60.3,36.8,56.1,63.1,52.7,39.6,51.9,39.0&chxs=0,990000,11,0,_|1,990000,1,0,_|2,990000,1,0,_&chm=o,990000,0,50,5&cht=lc&chxl=0:|0.17|1:||2:||&chco=336699&chxp=0,38.9904542844803&chls=1,1,0&chs=500x100"

# Acknowledgements 

The styling for the Sparklines was shamelessly stolen from [Jonathan Corum](http://www.style.org/chartapi/sparklines/); I essentially re-implemented his online tool.