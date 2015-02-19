json.array!(@games) do |game|
  json.extract! game, :id, :user_email, :opponent_user_email, :user_pieces, :opponent_pieces, :round, :user_turn_email
  json.url game_url(game, format: :json)
end
