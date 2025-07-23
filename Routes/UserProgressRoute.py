from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, Boolean, DateTime, ForeignKey
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import Base, get_db
from datetime import datetime

router = APIRouter()


# SQLAlchemy UserProgress model
class UserProgressModel(Base):
    __tablename__ = "UserProgress"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("Users.id"), nullable=False)
    lesson_id = Column(Integer, ForeignKey("Lessons.id"), nullable=False)
    completed = Column(Boolean, default=False)
    completed_at = Column(DateTime, nullable=True)


# Pydantic schemas
class UserProgressBase(BaseModel):
    user_id: int
    lesson_id: int
    completed: Optional[bool] = False
    completed_at: Optional[datetime] = None


class UserProgressCreate(UserProgressBase):
    pass


class UserProgress(UserProgressBase):
    id: int

    class Config:
        orm_mode = True


@router.get("/user-progress", response_model=List[UserProgress])
async def get_user_progresses(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(UserProgressModel))
    progresses = result.scalars().all()
    return progresses


@router.get("/user-progress/{progress_id}", response_model=UserProgress)
async def get_user_progress(progress_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(UserProgressModel).where(UserProgressModel.id == progress_id)
    )
    progress = result.scalar_one_or_none()
    if progress is None:
        raise HTTPException(status_code=404, detail="User progress not found")
    return progress


@router.post(
    "/user-progress", response_model=UserProgress, status_code=status.HTTP_201_CREATED
)
async def create_user_progress(
    progress: UserProgressCreate, db: AsyncSession = Depends(get_db)
):
    db_progress = UserProgressModel(**progress.dict())
    db.add(db_progress)
    await db.commit()
    await db.refresh(db_progress)
    return db_progress


@router.put("/user-progress/{progress_id}", response_model=UserProgress)
async def update_user_progress(
    progress_id: int, progress: UserProgressCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(UserProgressModel).where(UserProgressModel.id == progress_id)
    )
    db_progress = result.scalar_one_or_none()
    if db_progress is None:
        raise HTTPException(status_code=404, detail="User progress not found")
    for key, value in progress.dict().items():
        setattr(db_progress, key, value)
    await db.commit()
    await db.refresh(db_progress)
    return db_progress


@router.delete("/user-progress/{progress_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user_progress(progress_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(UserProgressModel).where(UserProgressModel.id == progress_id)
    )
    db_progress = result.scalar_one_or_none()
    if db_progress is None:
        raise HTTPException(status_code=404, detail="User progress not found")
    await db.delete(db_progress)
    await db.commit()
    return None
