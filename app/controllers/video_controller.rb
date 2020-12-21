class VideoController < ApplicationController
  
  def index
    vimeo_client = VimeoMe2::VimeoObject.new('4123f8e58da9644c05d74773b1fea627')
    res = vimeo_client.get('/users/129575771/projects/3238764/videos?per_page=50&page=1')
    videolist = []
    res["data"].each { |video| 
      uri = video["uri"].split("/")
      videolist.push({
        "id" => uri[2].split(":")[0],
        "name" => video["name"],
        "thumbnail" => video["pictures"]["sizes"][2]["link"]
      })
    }
    @videos = videolist
  end
end
