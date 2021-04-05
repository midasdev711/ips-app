class VideoController < ApplicationController
  
  def index
    vimeo_client = VimeoMe2::VimeoObject.new('4123f8e58da9644c05d74773b1fea627')
    res = vimeo_client.get('/users/129575771/projects/3259111/videos?direction=asc&per_page=50&page=1&sort=name')
    videolist = []
    res["data"].each.with_index(1) { |video, index| 
      uri = video["uri"].split("/")
      videolist.push({
        "id" => uri[2].split(":")[0],
        "index" => "#{index}. ",
        "name" => "#{video['name']}",
        "thumbnail" => video["pictures"]["sizes"][2]["link"]
      })
    }
    @videos = videolist
  end
end
