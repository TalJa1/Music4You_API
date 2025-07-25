PRAGMA foreign_keys = ON;

-- Drop all existing tables to avoid conflicts (drop child tables first)
DROP TABLE IF EXISTS UserProgress;

DROP TABLE IF EXISTS Achievements;

DROP TABLE IF EXISTS PracticeRooms;

DROP TABLE IF EXISTS Exercises;

DROP TABLE IF EXISTS Songs;

DROP TABLE IF EXISTS Instruments;

DROP TABLE IF EXISTS Lessons;

DROP TABLE IF EXISTS Users;

CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    avatar_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT
    OR IGNORE INTO Users (username, email, avatar_url)
VALUES (
        'musiclover',
        'lover@example.com',
        'https://example.com/avatar1.png'
    ),
    (
        'notemaster',
        'note@example.com',
        'https://example.com/avatar2.png'
    );

CREATE TABLE IF NOT EXISTS Lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    level TEXT,
    media_id TEXT, -- YouTube video ID only
    lesson_link TEXT, -- Link to the lesson from web
    type TEXT
);

INSERT
    OR IGNORE INTO Lessons (
        title,
        description,
        level,
        media_id,
        lesson_link,
        type
    )
VALUES (
        'Basic Notes',
        'Learn the basic musical notes, including their names, positions on the staff, and how they relate to the keys on a piano. This lesson covers the fundamentals of reading sheet music, recognizing note values, and understanding the musical alphabet. You will also practice identifying notes by ear and through interactive exercises, building a strong foundation for all future music learning.',
        'basic',
        'AmC_qmSODEk',
        'https://en.wikipedia.org/wiki/Musical_note',
        'note'
    ),
    (
        'Understanding Rhythm',
        'Explore the fundamental concepts of rhythm in music, including beat, tempo, meter, and syncopation. This lesson will help you understand how different note durations and rests create rhythmic patterns and how to feel and internalize a steady pulse. Practical exercises will focus on clapping rhythms, playing with a metronome, and recognizing various rhythmic figures in popular songs.',
        'basic',
        'ZJIbf4nMG3Y',
        'https://en.wikipedia.org/wiki/Rhythm',
        'rhythm'
    ),
    (
        'Major and Minor Scales',
        'Delve into the construction and sound of major and minor scales, the building blocks of melodies and harmonies. You will learn the specific interval patterns for each scale type, how to play them on an instrument, and how to identify their characteristic sounds. The lesson also touches on key signatures and their relation to scales.',
        'basic',
        'rxaNn1gXg-E',
        'https://en.wikipedia.org/wiki/Scale_(music)',
        'scale'
    ),
    (
        'Introduction to Harmony',
        'Discover the fascinating world of harmony beyond basic chords. This lesson introduces concepts like consonance and dissonance, voice leading principles, and simple chord progressions. You will learn how different chords interact to create emotional impact and how to analyze basic harmonic structures in music.',
        'intermediate',
        'D2ltRa2BosE',
        'https://en.wikipedia.org/wiki/Harmony',
        'harmony'
    ),
    (
        'Ear Training Fundamentals',
        'Develop your musical ear by learning to identify intervals, chords, and simple melodies by sound. This lesson provides practical exercises and techniques to improve your aural perception, a crucial skill for any musician. Topics include recognizing major/minor intervals, distinguishing chord qualities, and dictating simple tunes.',
        'basic',
        'Wzqa44N-sIU',
        'https://en.wikipedia.org/wiki/Ear_training',
        'ear_training'
    ),
    (
        'Counterpoint Principles',
        'Explore the art of counterpoint, where two or more independent melodic lines are interwoven to create a harmonious whole. This lesson covers the basic species of counterpoint, focusing on melodic independence and proper voice leading. It is an essential topic for composers and those seeking a deeper understanding of classical music.',
        'advanced',
        'TwPn47Ad_sE',
        'https://en.wikipedia.org/wiki/Counterpoint',
        'composition'
    ),
    (
        'Music Form and Analysis',
        'Understand the structural elements that define musical compositions. This lesson introduces common musical forms such as binary, ternary, sonata form, and rondo. You will learn to identify these forms in various pieces of music and analyze how different sections contribute to the overall structure and narrative of a work.',
        'advanced',
        'Y_5K8f5CZpg',
        'https://en.wikipedia.org/wiki/Musical_form',
        'analysis'
    ),
    (
        'Chord Theory',
        'This lesson provides a comprehensive introduction to chord structures, including major, minor, diminished, and augmented chords. You will learn how chords are constructed from intervals, how to identify them by ear, and how to play them on your instrument. The lesson also explores chord progressions, voice leading, and practical applications in popular music, with plenty of examples and exercises to reinforce your understanding.',
        'intermediate',
        'VNhyD4O4HWg',
        'https://en.wikipedia.org/wiki/Chord_(music)',
        'chord'
    ),
    (
        'Orchestration Basics',
        'An introduction to the principles of orchestration, the art of assigning musical parts to different instruments in an ensemble. This lesson covers the characteristics and common uses of various orchestral instruments (strings, woodwinds, brass, percussion) and how to blend their sounds effectively to create rich and varied timbres.',
        'advanced',
        'fjzjGhN56Ok',
        'https://en.wikipedia.org/wiki/Orchestration',
        'orchestration'
    ),
    (
        'Reading Sheet Music',
        'Master the fundamentals of reading standard musical notation. This lesson covers staffs, clefs, time signatures, key signatures, and the placement of notes and rests. Practical exercises will help you confidently interpret and perform music from a score.',
        'basic',
        '-3WuQxnA7Hg',
        'https://en.wikipedia.org/wiki/Musical_notation',
        'notation'
    );

CREATE TABLE IF NOT EXISTS Exercises (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER,
    title TEXT NOT NULL,
    type TEXT,
    content TEXT,
    FOREIGN KEY (lesson_id) REFERENCES Lessons (id)
);

INSERT
    OR IGNORE INTO Exercises (
        lesson_id,
        title,
        type,
        content
    )
VALUES
    -- Exercises for lesson 1
    (
        1,
        'What is the name of the note on the second line of the treble staff?',
        'note_recognition',
        'G'
    ),
    (
        1,
        'Which note is located between C and E?',
        'note_recognition',
        'D'
    ),
    (
        1,
        'What is the value of a whole note?',
        'note_recognition',
        '4 beats'
    ),
    (
        1,
        'Which note is represented by the first space in the bass clef?',
        'note_recognition',
        'A'
    ),
    (
        1,
        'What is the musical alphabet?',
        'note_recognition',
        'A B C D E F G'
    ),
    -- Exercises for lesson 2
    (
        2,
        'What is the time signature for common time?',
        'rhythm',
        '4/4'
    ),
    (
        2,
        'How many beats does a dotted quarter note get?',
        'rhythm',
        '1.5 beats'
    ),
    (
        2,
        'What is syncopation?',
        'rhythm',
        'Emphasis on off-beats'
    ),
    (
        2,
        'What is the tempo marking for a slow pace?',
        'rhythm',
        'Largo'
    ),
    (
        2,
        'Which note value is the shortest: quarter, eighth, or sixteenth?',
        'rhythm',
        'Sixteenth note'
    ),
    -- Exercises for lesson 3
    (
        3,
        'What is the interval pattern for a major scale?',
        'scale',
        'W W H W W W H'
    ),
    (
        3,
        'What is the relative minor of C major?',
        'scale',
        'A minor'
    ),
    (
        3,
        'How many sharps are in the G major scale?',
        'scale',
        '1'
    ),
    (
        3,
        'What is the key signature for F major?',
        'scale',
        '1 flat (Bb)'
    ),
    (
        3,
        'Which scale has all white keys on the piano?',
        'scale',
        'C major'
    ),
    -- Exercises for lesson 4
    (
        4,
        'What is consonance in music?',
        'harmony',
        'Pleasant-sounding combination of notes'
    ),
    (
        4,
        'What is a simple chord progression in C major?',
        'harmony',
        'C - F - G - C'
    ),
    (
        4,
        'What is voice leading?',
        'harmony',
        'Smooth movement between chords'
    ),
    (
        4,
        'What is a dissonant interval?',
        'harmony',
        'Minor second or tritone'
    ),
    (
        4,
        'What is the tonic chord in G major?',
        'harmony',
        'G major'
    ),
    -- Exercises for lesson 5
    (
        5,
        'What is an interval?',
        'ear_training',
        'The distance between two notes'
    ),
    (
        5,
        'How do you identify a major third by ear?',
        'ear_training',
        'It sounds happy and is 4 semitones apart'
    ),
    (
        5,
        'What is the difference between a major and minor chord?',
        'ear_training',
        'The third is lowered in a minor chord'
    ),
    (
        5,
        'What is melodic dictation?',
        'ear_training',
        'Writing down a melody you hear'
    ),
    (
        5,
        'What is the interval between C and G?',
        'ear_training',
        'Perfect fifth'
    ),
    -- Exercises for lesson 6
    (
        6,
        'What is counterpoint?',
        'composition',
        'The art of combining independent melodies'
    ),
    (
        6,
        'What is species counterpoint?',
        'composition',
        'A method of teaching counterpoint in stages'
    ),
    (
        6,
        'What is voice independence?',
        'composition',
        'Each melodic line stands on its own'
    ),
    (
        6,
        'What is proper voice leading?',
        'composition',
        'Smooth, logical movement between notes'
    ),
    (
        6,
        'What is a canon?',
        'composition',
        'A melody that is imitated after a delay'
    ),
    -- Exercises for lesson 7
    (
        7,
        'What is binary form?',
        'analysis',
        'A musical form with two sections (AB)'
    ),
    (
        7,
        'What is sonata form?',
        'analysis',
        'Exposition, development, recapitulation'
    ),
    (
        7,
        'What is a rondo?',
        'analysis',
        'A form with a recurring theme (ABACA)'
    ),
    (
        7,
        'What is the purpose of musical analysis?',
        'analysis',
        'To understand structure and meaning'
    ),
    (
        7,
        'What is ternary form?',
        'analysis',
        'A musical form with three sections (ABA)'
    ),
    -- Exercises for lesson 8
    (
        8,
        'What is a major chord?',
        'chord',
        'A chord with a root, major third, and perfect fifth'
    ),
    (
        8,
        'What is a diminished chord?',
        'chord',
        'A chord with a root, minor third, and diminished fifth'
    ),
    (
        8,
        'What is a chord progression?',
        'chord',
        'A sequence of chords played in succession'
    ),
    (
        8,
        'What is voice leading in chords?',
        'chord',
        'Smooth movement between chord tones'
    ),
    (
        8,
        'What is an augmented chord?',
        'chord',
        'A chord with a root, major third, and augmented fifth'
    ),
    -- Exercises for lesson 9
    (
        9,
        'What is orchestration?',
        'orchestration',
        'Assigning music to different instruments'
    ),
    (
        9,
        'Name a woodwind instrument.',
        'orchestration',
        'Flute'
    ),
    (
        9,
        'What is a string section?',
        'orchestration',
        'Violins, violas, cellos, basses'
    ),
    (
        9,
        'What is timbre?',
        'orchestration',
        'The color or quality of a musical sound'
    ),
    (
        9,
        'What is a brass instrument?',
        'orchestration',
        'Trumpet'
    ),
    -- Exercises for lesson 10
    (
        10,
        'What is a staff?',
        'notation',
        'The set of five lines and four spaces for writing music'
    ),
    (
        10,
        'What is a clef?',
        'notation',
        'A symbol that indicates pitch range'
    ),
    (
        10,
        'What is a time signature?',
        'notation',
        'Indicates beats per measure and note value'
    ),
    (
        10,
        'What is a key signature?',
        'notation',
        'Indicates which notes are sharp or flat'
    ),
    (
        10,
        'What is a rest?',
        'notation',
        'A symbol for silence in music'
    );

CREATE TABLE IF NOT EXISTS Songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    artist TEXT,
    level TEXT,
    sheet_url TEXT,
    video_id TEXT -- YouTube video ID only
);

INSERT
    OR IGNORE INTO Songs (
        title,
        artist,
        level,
        sheet_url,
        video_id
    )
VALUES (
        'Sonata No. 14 "Moonlight"',
        'Ludwig van Beethoven',
        'basic',
        'https://www.free-scores.com/PDF/beethoven-ludwig-van-sonata-282.pdf',
        'BV7RkEL6oRc'
    ),
    (
        'Clair de lune',
        'Claude Debussy',
        'intermediate',
        'https://www.free-scores.com/PDF/debussy-claude-clair-lune-608-745.pdf',
        'WNcsUNKlAKw'
    ),
    (
        'Nocturne in E Flat Major (Op. 9 No. 2)',
        'Chopin',
        'intermediate',
        'https://www.free-scores.com/PDF/chopin-fra-ric-chopin-op009-nocturnos-81865.pdf',
        'p29JUpsOSTE'
    );

CREATE TABLE IF NOT EXISTS Instruments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT
);

INSERT
    OR IGNORE INTO Instruments (name, type)
VALUES ('Piano', 'keyboard'),
    ('Guitar', 'string');

CREATE TABLE IF NOT EXISTS PracticeRooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_name TEXT NOT NULL,
    host_user_id INTEGER,
    instrument TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (host_user_id) REFERENCES Users (id)
);

INSERT
    OR IGNORE INTO PracticeRooms (
        room_name,
        host_user_id,
        instrument
    )
VALUES ('Morning Jam', 1, 'Guitar'),
    ('Night Practice', 2, 'Piano');

CREATE TABLE IF NOT EXISTS Achievements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id)
);

INSERT
    OR IGNORE INTO Achievements (user_id, title, description)
VALUES (
        1,
        'First Lesson Complete',
        'Completed your first lesson!'
    ),
    (
        2,
        'Chord Master',
        'Completed all chord lessons'
    );

CREATE TABLE IF NOT EXISTS UserProgress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    lesson_id INTEGER,
    completed BOOLEAN DEFAULT 0,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users (id),
    FOREIGN KEY (lesson_id) REFERENCES Lessons (id)
);

INSERT
    OR IGNORE INTO UserProgress (
        user_id,
        lesson_id,
        completed,
        completed_at
    )
VALUES (
        1,
        1,
        1,
        '2025-07-20 08:00:00'
    ),
    (
        2,
        2,
        1,
        '2025-07-19 14:30:00'
    );