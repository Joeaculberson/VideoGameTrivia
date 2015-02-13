json.array!(@games) do |game|
  json.extract! game, :id, :opponent, :your_pieces, :opponent_pieces
  json.url game_url(game, format: :json)
end
