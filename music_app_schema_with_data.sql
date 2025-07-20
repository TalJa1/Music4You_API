PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    avatar_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO Users (username, email, avatar_url) VALUES
('musiclover', 'lover@example.com', 'https://example.com/avatar1.png'),
('notemaster', 'note@example.com', 'https://example.com/avatar2.png');

CREATE TABLE IF NOT EXISTS Lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    level TEXT,
    media_url TEXT,
    type TEXT
);

INSERT OR IGNORE INTO Lessons (title, description, level, media_url, type) VALUES
('Basic Notes', 'Learn the basic musical notes', 'basic', 'https://example.com/note1.mp4', 'note'),
('Chord Theory', 'Introduction to chord structures', 'intermediate', 'https://example.com/chord.mp4', 'chord');

CREATE TABLE IF NOT EXISTS Exercises (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER,
    title TEXT NOT NULL,
    type TEXT,
    content TEXT,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
);

INSERT OR IGNORE INTO Exercises (lesson_id, title, type, content) VALUES
(1, 'Note Recognition Quiz', 'note_recognition', 'Identify the notes from audio clips'),
(2, 'Chord Matching', 'chord_identification', 'Choose the right chord from the audio');

CREATE TABLE IF NOT EXISTS Songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    artist TEXT,
    level TEXT,
    sheet_url TEXT,
    video_url TEXT
);

INSERT OR IGNORE INTO Songs (title, artist, level, sheet_url, video_url) VALUES
('Let It Be', 'The Beatles', 'basic', 'https://example.com/letitbe.pdf', 'https://example.com/letitbe.mp4'),
('River Flows in You', 'Yiruma', 'intermediate', 'https://example.com/riverflows.pdf', 'https://example.com/riverflows.mp4');

CREATE TABLE IF NOT EXISTS Instruments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT
);

INSERT OR IGNORE INTO Instruments (name, type) VALUES
('Piano', 'keyboard'),
('Guitar', 'string');

CREATE TABLE IF NOT EXISTS PracticeRooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_name TEXT NOT NULL,
    host_user_id INTEGER,
    instrument TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO PracticeRooms (room_name, host_user_id, instrument) VALUES
('Morning Jam', 1, 'Guitar'),
('Night Practice', 2, 'Piano');

CREATE TABLE IF NOT EXISTS Achievements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

INSERT OR IGNORE INTO Achievements (user_id, title, description) VALUES
(1, 'First Lesson Complete', 'Completed your first lesson!'),
(2, 'Chord Master', 'Completed all chord lessons');

CREATE TABLE IF NOT EXISTS UserProgress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    lesson_id INTEGER,
    completed BOOLEAN DEFAULT 0,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
);

INSERT OR IGNORE INTO UserProgress (user_id, lesson_id, completed, completed_at) VALUES
(1, 1, 1, '2025-07-20 08:00:00'),
(2, 2, 1, '2025-07-19 14:30:00');
