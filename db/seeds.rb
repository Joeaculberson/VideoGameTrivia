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

Question.create([
                    :question_text      => 'How many rows of aliens are there usually at the start of a ‘Space Invaders’ game?',
                    :correct_answer     => '5',
                    :incorrect_answer_1 => '12',
                    :incorrect_answer_2 => '3',
                    :incorrect_answer_3 => '8',
                    :category           => 'arcade',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'How many copies of the famously awful E.T. game for the Atari 2600 were sold?',
                    :correct_answer     => '1.5 Million',
                    :incorrect_answer_1 => '1 Million',
                    :incorrect_answer_2 => '2.5 Million',
                    :incorrect_answer_3 => '2 Million',
                    :category           => 'arcade',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'In Fallout 3, what vault does the player start out in?',
                    :correct_answer     => '101',
                    :incorrect_answer_1 => '77',
                    :incorrect_answer_2 => '132',
                    :incorrect_answer_3 => '89',
                    :category           => 'fps',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'How many Stars is it possible to collect in the game Super Mario 64?',
                    :correct_answer     => '120',
                    :incorrect_answer_1 => '140',
                    :incorrect_answer_2 => '100',
                    :incorrect_answer_3 => '280',
                    :category           => 'adventure',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'Who is the first boss in Diddy Kong Racing?',
                    :correct_answer     => 'Tricky the Triceratops',
                    :incorrect_answer_1 => 'Bubbler the Octopus',
                    :incorrect_answer_2 => 'Smokey the Dragon',
                    :incorrect_answer_3 => 'Bluey the Walrus',
                    :category           => 'racing',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'Which of the following is not a playable race in Dragon Age: Origins?',
                    :correct_answer     => 'Dragonborn',
                    :incorrect_answer_1 => 'Dwarf',
                    :incorrect_answer_2 => 'Human',
                    :incorrect_answer_3 => 'Elf',
                    :category           => 'role-playing',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'How many player races are their in Skyrim?',
                    :correct_answer     => '10',
                    :incorrect_answer_1 => '8',
                    :incorrect_answer_2 => '12',
                    :incorrect_answer_3 => '6',
                    :category           => 'role-playing',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'Call of Duty: Modern Warfare 2 is the ____ game in the Call of Duty series.',
                    :correct_answer     => '5th',
                    :incorrect_answer_1 => '3nd',
                    :incorrect_answer_2 => '4rd',
                    :incorrect_answer_3 => '2th',
                    :category           => 'fps',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'Who do you play as in Grand Theft Auto: Vice City?',
                    :correct_answer     => 'Tommy Vercetti',
                    :incorrect_answer_1 => 'Lance Vance',
                    :incorrect_answer_2 => 'Andy Kaufman',
                    :incorrect_answer_3 => 'Donald Love',
                    :category           => 'action',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])

Question.create([
                    :question_text      => 'In Grand Theft Auto: Vice City, at what wanted level does the FBI begin pursuing you?',
                    :correct_answer     => 'Five Stars',
                    :incorrect_answer_1 => 'Six Stars',
                    :incorrect_answer_2 => 'Four Stars',
                    :incorrect_answer_3 => 'Seven Stars',
                    :category           => 'action',
                    :created_at         => DateTime.new,
                    :updated_at         => DateTime.new,
                    :is_authorized      => true,
                    :submitter          => 'Fausett'
                ])