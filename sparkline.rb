
# A simple class that generates sparklines using google chart api
# (vincentc, 9/10/2010)
class Sparkline
  
  BASE_URL = %Q[http://chart.apis.google.com/chart]
  MIN_DELTA = 10
  
  attr_accessor :data, :height, :width, :color

  def initialize( data, options = {} )
    @data   = data
    @height = (options[:height] || 70)
    @width  = (options[:width]  || 300)    
    
    @normalized_data = @data.clone
    @data_resampled  = []
  end  

  def google_img_url
    resample_data!

    normalize_data!
    adjust_slope!
    data_str = @normalized_data.collect {|d| sprintf("%.1f", d.to_f)}.join(",")
    
    options = {
      :cht => "lc",
      :chco => 336699,
      :chls => "1,1,0",
      :chxt => "r,x,y",
      :chxs => "0,990000,11,0,_|1,990000,1,0,_|2,990000,1,0,_"
    }
    
    options[:chm] = "o,990000,0,#{@normalized_data.length},5" 
    options[:chxl] = "0:|#{sprintf("%.2f", @data.last.to_f)}|1:||2:||"
    options[:chxp] = "0,#{@normalized_data.last}"
    options[:chs] = "#{@width}x#{@height}"
    options[:chd] = "t:" + data_str
        
    url = BASE_URL.clone
    url = url + "?" + options.to_a.collect {|p| p.join("=")}.join("&")
    
    url
  end

  private

  def resample_data!
    n_pts = @normalized_data.length
    nn = (@width / MIN_DELTA).to_i
    
    if (nn < n_pts)
      resampled = []
      skip = (n_pts / nn)
      @normalized_data.each_with_index do |d, i|
        if (i%skip == 0)
          resampled << d 
          @data_resampled << @data[i]
        end
      end
      
      @normalized_data = resampled
    else
      @data_resampled = @data.clone
    end
  end

  def normalize_data!
    n_pts = @normalized_data.length    
    avg_value = @normalized_data.each.inject {|m, i| m += i } / n_pts.to_f
    @normalized_data.collect! {|d| d - avg_value }    
  end
  
  def adjust_slope!
    n_pts = @normalized_data.length
    avg_slope = (1..(n_pts-1)).each.inject(0) do |avg, index|      
      avg += (@normalized_data[index] - @normalized_data[index-1]).abs
    end
    avg_slope *= (@height.to_f / (100.0 * @width.to_f))
    
    @normalized_data.collect! {|x| (x/avg_slope)}

    min_val = @normalized_data.min
    max_val = @normalized_data.max
    max_max = [min_val.abs, max_val.abs].max
    
    if (max_max > 50.0)  
      @normalized_data.collect! { |d| d * (50.0/max_max)}
    end
        
    @normalized_data.collect! {|d| d + 50.0 }
  end
end


data = 1000.times.inject([]) { |m, k| m << rand }
sparkline = Sparkline.new( data, :height => 100, :width => 500 )
puts sparkline.google_img_url
# => "http://chart.apis.google.com/chart?chxt=r,x,y&chd=t:41.5,34.3,63.4,45.0,50.5,35.7,40.6,54.9,62.0,60.6,53.2,44.9,62.4,61.8,53.5,58.5,60.4,64.6,64.5,49.8,49.3,61.4,46.4,50.8,36.1,46.5,52.8,39.7,44.4,42.3,57.6,45.6,34.1,49.0,64.1,61.4,59.9,34.0,43.9,44.8,40.4,34.0,60.3,36.8,56.1,63.1,52.7,39.6,51.9,39.0&chxs=0,990000,11,0,_|1,990000,1,0,_|2,990000,1,0,_&chm=o,990000,0,50,5&cht=lc&chxl=0:|0.17|1:||2:||&chco=336699&chxp=0,38.9904542844803&chls=1,1,0&chs=500x100"

data = File.open("co2_ppm", "r").readlines.collect(&:to_f)
sparkline = Sparkline.new( data, :height => 150, :width => 500 )
puts sparkline.google_img_url

