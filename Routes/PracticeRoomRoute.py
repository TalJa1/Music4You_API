from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import Base, get_db
from datetime import datetime

router = APIRouter()


# SQLAlchemy PracticeRoom model
class PracticeRoomModel(Base):
    __tablename__ = "PracticeRooms"
    id = Column(Integer, primary_key=True, index=True)
    room_name = Column(String, nullable=False)
    host_user_id = Column(Integer, ForeignKey("Users.id"))
    instrument = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)


# Pydantic schemas
class PracticeRoomBase(BaseModel):
    room_name: str
    host_user_id: Optional[int] = None
    instrument: Optional[str] = None


class PracticeRoomCreate(PracticeRoomBase):
    pass


class PracticeRoom(PracticeRoomBase):
    id: int
    created_at: Optional[datetime] = None

    class Config:
        orm_mode = True


@router.get("/practice-rooms", response_model=List[PracticeRoom])
async def get_practice_rooms(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(PracticeRoomModel))
    rooms = result.scalars().all()
    return rooms


@router.get("/practice-rooms/by-user/{user_id}", response_model=List[PracticeRoom])
async def get_practice_rooms_by_user(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(PracticeRoomModel).where(PracticeRoomModel.host_user_id == user_id)
    )
    rooms = result.scalars().all()
    return rooms


@router.get("/practice-rooms/{room_id}", response_model=PracticeRoom)
async def get_practice_room(room_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(PracticeRoomModel).where(PracticeRoomModel.id == room_id)
    )
    room = result.scalar_one_or_none()
    if room is None:
        raise HTTPException(status_code=404, detail="Practice room not found")
    return room


@router.get(
    "/practice-rooms/by-instrument/{instrument}", response_model=List[PracticeRoom]
)
async def get_practice_rooms_by_instrument(
    instrument: str, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(PracticeRoomModel).where(
            func.lower(PracticeRoomModel.instrument) == instrument.lower()
        )
    )
    rooms = result.scalars().all()
    return rooms


@router.post(
    "/practice-rooms", response_model=PracticeRoom, status_code=status.HTTP_201_CREATED
)
async def create_practice_room(
    room: PracticeRoomCreate, db: AsyncSession = Depends(get_db)
):
    db_room = PracticeRoomModel(**room.dict())
    db.add(db_room)
    await db.commit()
    await db.refresh(db_room)
    return db_room


@router.put("/practice-rooms/{room_id}", response_model=PracticeRoom)
async def update_practice_room(
    room_id: int, room: PracticeRoomCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(PracticeRoomModel).where(PracticeRoomModel.id == room_id)
    )
    db_room = result.scalar_one_or_none()
    if db_room is None:
        raise HTTPException(status_code=404, detail="Practice room not found")
    for key, value in room.dict().items():
        setattr(db_room, key, value)
    await db.commit()
    await db.refresh(db_room)
    return db_room


@router.delete("/practice-rooms/{room_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_practice_room(room_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(PracticeRoomModel).where(PracticeRoomModel.id == room_id)
    )
    db_room = result.scalar_one_or_none()
    if db_room is None:
        raise HTTPException(status_code=404, detail="Practice room not found")
    await db.delete(db_room)
    await db.commit()
    return None
