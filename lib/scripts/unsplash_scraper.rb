require 'nokogiri'
require 'open-uri'
require 'json'

UNSPLASH_ARCHIVE_PAGE = "http://unsplash.com/archive"
date = DateTime.now
year = date.year
month = date.month
month_with_leading_zero = date.strftime('%m')

unsplash_imgs = {}

while true

  unsplash_archive_month = Nokogiri::HTML(open("#{UNSPLASH_ARCHIVE_PAGE}/#{year}/#{month}"))

  # check if there are actually images in the month's container
  if unsplash_archive_month.css("#posts_#{year}#{month_with_leading_zero} .post a").count > 0
    unsplash_imgs["#{year}_#{month_with_leading_zero}"] = []
    unsplash_month_links = []

    # get the link to the image show page
    unsplash_archive_month.css("#posts_#{year}#{month_with_leading_zero} .post a").each do |a|
      unsplash_month_links << a['href']
    end

    # get the actual image source
    unsplash_month_links.each do |unsplash_img_page|
      img_page = Nokogiri::HTML(open(unsplash_img_page))

      unsplash_imgs["#{year}_#{month_with_leading_zero}"] << img_page.css(".post .photo_img")[0]["src"]
    end

    puts "Grabbed images from #{month}/#{year}..."

    # count down months/years
    if month - 1 == 0
      month = month_with_leading_zero = 12
      year -= 1
    else
      month -= 1
      if month < 10
        month_with_leading_zero = "%02d" % month
      else
        month_with_leading_zero = month
      end
    end

  else
    puts "Gathered all images."
    puts "Saving images..."

    # write da file
    imgs_file = File.open('unsplash_images.json', 'w')
    imgs_file.write(unsplash_imgs.to_json)
    imgs_file.close

    puts "Save complete. Great success."
    exit
  end

end
