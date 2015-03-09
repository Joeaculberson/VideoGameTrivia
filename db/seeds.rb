# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'admin@admin.com', password: 'admin', role: 'Admin')

Question.create([
                    :question_text      => 'In the game ‘Metal Gear Solid’,who is the twin brother of Solid Snake?',
                    :correct_answer     => 'Liquid Snake',
                    :incorrect_answer_1 => 'Big Boss',
                    :incorrect_answer_2 => 'Solidus Snake',
                    :incorrect_answer_3 => 'Raiden',
                    :category           => 'adventure',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'What is the name of the princess whom Mario repeatedly stops Bowser from kidnapping?',
                    :correct_answer     => 'Peach',
                    :incorrect_answer_1 => 'Daisy',
                    :incorrect_answer_2 => 'Rosalina',
                    :incorrect_answer_3 => 'Luigi',
                    :category           => 'arcade',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'What is the name of the gang member that video game ‘Grand Theft Auto: San Andreas’ revolves around?',
                    :correct_answer     => 'Carl Johnson',
                    :incorrect_answer_1 => 'Big Smoke',
                    :incorrect_answer_2 => 'Frank Tenpenny',
                    :incorrect_answer_3 => 'Ryder',
                    :category           => 'action',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'How many square blocks is each game piece composed of in the game of ‘Tetris’?',
                    :correct_answer     => '4',
                    :incorrect_answer_1 => '6',
                    :incorrect_answer_2 => '5',
                    :incorrect_answer_3 => '3',
                    :category           => 'arcade',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'In the computer game ‘The Sims’, how many Simoleons does each family start the game with?',
                    :correct_answer     => '20,000',
                    :incorrect_answer_1 => '10,000',
                    :incorrect_answer_2 => '35,000',
                    :incorrect_answer_3 => '40,000',
                    :category           => 'role-playing',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'what colour is Pac-Man?',
                    :correct_answer     => 'Yellow',
                    :incorrect_answer_1 => 'Red',
                    :incorrect_answer_2 => 'Green',
                    :incorrect_answer_3 => 'Blue',
                    :category           => 'arcade',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'Which 1997 Playstation game’s opening song is a Chemical Brothers remix of the Manic Street Preachers song ‘Everything Must Go’?',
                    :correct_answer     => 'Gran Turismo',
                    :incorrect_answer_1 => 'Formula One Grand Prix',
                    :incorrect_answer_2 => 'Ridge Racer',
                    :incorrect_answer_3 => 'Crazy Taxi',
                    :category           => 'racing',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'In the game ‘Doom’, which planet is the space marine posted to after assaulting his commanding officer?',
                    :correct_answer     => 'Mars',
                    :incorrect_answer_1 => 'Saturn',
                    :incorrect_answer_2 => 'Jupiter',
                    :incorrect_answer_3 => 'Neptune',
                    :category           => 'fps',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])