from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import Base, get_db

router = APIRouter()


# SQLAlchemy Song model
class SongModel(Base):
    __tablename__ = "Songs"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    artist = Column(String)
    level = Column(String)
    sheet_url = Column(String)
    video_id = Column(String)


# Pydantic schemas
class SongBase(BaseModel):
    title: str
    artist: Optional[str] = None
    level: Optional[str] = None
    sheet_url: Optional[str] = None
    video_id: Optional[str] = None


class SongCreate(SongBase):
    pass


class Song(SongBase):
    id: int

    class Config:
        orm_mode = True


@router.get("/songs", response_model=List[Song])
async def get_songs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SongModel))
    songs = result.scalars().all()
    return songs


@router.get("/songs/{song_id}", response_model=Song)
async def get_song(song_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SongModel).where(SongModel.id == song_id))
    song = result.scalar_one_or_none()
    if song is None:
        raise HTTPException(status_code=404, detail="Song not found")
    return song


@router.post("/songs", response_model=Song, status_code=status.HTTP_201_CREATED)
async def create_song(song: SongCreate, db: AsyncSession = Depends(get_db)):
    db_song = SongModel(**song.dict())
    db.add(db_song)
    await db.commit()
    await db.refresh(db_song)
    return db_song


@router.put("/songs/{song_id}", response_model=Song)
async def update_song(
    song_id: int, song: SongCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(SongModel).where(SongModel.id == song_id))
    db_song = result.scalar_one_or_none()
    if db_song is None:
        raise HTTPException(status_code=404, detail="Song not found")
    for key, value in song.dict().items():
        setattr(db_song, key, value)
    await db.commit()
    await db.refresh(db_song)
    return db_song


@router.delete("/songs/{song_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_song(song_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SongModel).where(SongModel.id == song_id))
    db_song = result.scalar_one_or_none()
    if db_song is None:
        raise HTTPException(status_code=404, detail="Song not found")
    await db.delete(db_song)
    await db.commit()
    return None
