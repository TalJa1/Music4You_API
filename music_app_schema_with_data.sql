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