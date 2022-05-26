require_relative './query'
require_relative '../classes/music_album'
require_relative './utils'

class MusicAlbumsController
  def initialize
    @music_albums = Query.read('albums').map { |json| MusicAlbum.from_json(json) }
  end

  def add_music_album(album_hash)
    puts '
    Please enter the following information:'
    print 'Album name: '
    album = gets.chomp
    on_spotify = Utils.get_valid_boolean
    publish_date = Utils.get_valid_date('Publish date')
    music_album = MusicAlbum.new(album, on_spotify, publish_date)
    @music_albums.push(music_album)
  end

  def list_music_albums
    if @music_albums.length.zero?
      puts 'The album list is empty! Please add a music album first!'
    else
      puts
      puts 'The music albums list: '
      @music_albums.each_with_index do |album, index|
        puts "#{index + 1}- name: #{album.publisher},
          On spotify: #{album.cover_state},
          Publish date: #{album.publish_date}"
      end
    end
    @music_albums
  end

  def store_albums
    albums = @music_albums.map(&:to_json)
    albums_json = JSON.generate(albums)
    Query.write('albums', albums_json)
  end
end
