from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import Base, get_db

router = APIRouter()


# SQLAlchemy Lesson model
class LessonModel(Base):
    __tablename__ = "Lessons"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String)
    level = Column(String)
    media_id = Column(String)
    lesson_link = Column(String)
    type = Column(String)


# Pydantic schemas
class LessonBase(BaseModel):
    title: str
    description: Optional[str] = None
    level: Optional[str] = None
    media_id: Optional[str] = None
    lesson_link: Optional[str] = None
    type: Optional[str] = None


class LessonCreate(LessonBase):
    pass


class Lesson(LessonBase):
    id: int

    class Config:
        orm_mode = True


@router.get("/lessons", response_model=List[Lesson])
async def get_lessons(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(LessonModel))
    lessons = result.scalars().all()
    return lessons


@router.get("/lessons/{lesson_id}", response_model=Lesson)
async def get_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(LessonModel).where(LessonModel.id == lesson_id))
    lesson = result.scalar_one_or_none()
    if lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return lesson


@router.post("/lessons", response_model=Lesson, status_code=status.HTTP_201_CREATED)
async def create_lesson(lesson: LessonCreate, db: AsyncSession = Depends(get_db)):
    db_lesson = LessonModel(**lesson.dict())
    db.add(db_lesson)
    await db.commit()
    await db.refresh(db_lesson)
    return db_lesson


@router.put("/lessons/{lesson_id}", response_model=Lesson)
async def update_lesson(
    lesson_id: int, lesson: LessonCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(LessonModel).where(LessonModel.id == lesson_id))
    db_lesson = result.scalar_one_or_none()
    if db_lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    for key, value in lesson.dict().items():
        setattr(db_lesson, key, value)
    await db.commit()
    await db.refresh(db_lesson)
    return db_lesson


@router.delete("/lessons/{lesson_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(LessonModel).where(LessonModel.id == lesson_id))
    db_lesson = result.scalar_one_or_none()
    if db_lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    await db.delete(db_lesson)
    await db.commit()
    return None
