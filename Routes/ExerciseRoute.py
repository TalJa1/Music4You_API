from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import Base, get_db

router = APIRouter()


# SQLAlchemy Exercise model
class ExerciseModel(Base):
    __tablename__ = "Exercises"
    id = Column(Integer, primary_key=True, index=True)
    lesson_id = Column(Integer, ForeignKey("Lessons.id"), nullable=False)
    title = Column(String, nullable=False)
    type = Column(String)
    content = Column(String)


# Pydantic schemas
class ExerciseBase(BaseModel):
    lesson_id: int
    title: str
    type: Optional[str] = None
    content: Optional[str] = None


class ExerciseCreate(ExerciseBase):
    pass


class Exercise(ExerciseBase):
    id: int

    class Config:
        orm_mode = True


# Get all exercises by lesson_id
@router.get("/exercises/by-lesson/{lesson_id}", response_model=List[Exercise])
async def get_exercises_by_lesson(lesson_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ExerciseModel).where(ExerciseModel.lesson_id == lesson_id)
    )
    exercises = result.scalars().all()
    return exercises


@router.get("/exercises", response_model=List[Exercise])
async def get_exercises(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(ExerciseModel))
    exercises = result.scalars().all()
    return exercises


@router.get("/exercises/{exercise_id}", response_model=Exercise)
async def get_exercise(exercise_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ExerciseModel).where(ExerciseModel.id == exercise_id)
    )
    exercise = result.scalar_one_or_none()
    if exercise is None:
        raise HTTPException(status_code=404, detail="Exercise not found")
    return exercise


@router.post("/exercises", response_model=Exercise, status_code=status.HTTP_201_CREATED)
async def create_exercise(exercise: ExerciseCreate, db: AsyncSession = Depends(get_db)):
    db_exercise = ExerciseModel(**exercise.dict())
    db.add(db_exercise)
    await db.commit()
    await db.refresh(db_exercise)
    return db_exercise


@router.put("/exercises/{exercise_id}", response_model=Exercise)
async def update_exercise(
    exercise_id: int, exercise: ExerciseCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(ExerciseModel).where(ExerciseModel.id == exercise_id)
    )
    db_exercise = result.scalar_one_or_none()
    if db_exercise is None:
        raise HTTPException(status_code=404, detail="Exercise not found")
    for key, value in exercise.dict().items():
        setattr(db_exercise, key, value)
    await db.commit()
    await db.refresh(db_exercise)
    return db_exercise


@router.delete("/exercises/{exercise_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_exercise(exercise_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(ExerciseModel).where(ExerciseModel.id == exercise_id)
    )
    db_exercise = result.scalar_one_or_none()
    if db_exercise is None:
        raise HTTPException(status_code=404, detail="Exercise not found")
    await db.delete(db_exercise)
    await db.commit()
    return None
