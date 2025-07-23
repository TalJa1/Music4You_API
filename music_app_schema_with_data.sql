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
        'Chord Theory',
        'This lesson provides a comprehensive introduction to chord structures, including major, minor, diminished, and augmented chords. You will learn how chords are constructed from intervals, how to identify them by ear, and how to play them on your instrument. The lesson also explores chord progressions, voice leading, and practical applications in popular music, with plenty of examples and exercises to reinforce your understanding.',
        'intermediate',
        'VNhyD4O4HWg',
        'https://en.wikipedia.org/wiki/Chord_(music)',
        'chord'
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
VALUES (
        1,
        'Note Recognition Quiz',
        'note_recognition',
        'Identify the notes from audio clips'
    ),
    (
        2,
        'Chord Matching',
        'chord_identification',
        'Choose the right chord from the audio'
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