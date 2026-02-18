from sqlalchemy import Column, Integer, String, DateTime, func, UniqueConstraint
from .db import Base

class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(120), nullable=False)
    email = Column(String(200), nullable=False)
    service = Column(String(120), nullable=False)
    appointment_at = Column(DateTime(timezone=True), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("appointment_at", name="uq_appointment_at"),
    )
