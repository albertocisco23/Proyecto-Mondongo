from datetime import datetime
from pydantic import BaseModel, EmailStr, Field

class AppointmentCreate(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    email: EmailStr
    service: str = Field(min_length=2, max_length=120)
    appointment_at: datetime

class AppointmentOut(BaseModel):
    id: int
    name: str
    email: str
    service: str
    appointment_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True
