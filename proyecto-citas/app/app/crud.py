from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from .models import Appointment
from .schemas import AppointmentCreate

def create_appointment(db: Session, data: AppointmentCreate) -> Appointment:
    appt = Appointment(
        name=data.name,
        email=str(data.email),
        service=data.service,
        appointment_at=data.appointment_at,
    )
    db.add(appt)
    try:
        db.commit()
        db.refresh(appt)
        return appt
    except IntegrityError as e:
        db.rollback()
        raise e

def list_appointments(db: Session) -> list[Appointment]:
    return db.query(Appointment).order_by(Appointment.appointment_at.asc()).all()

def delete_appointment(db: Session, appt_id: int) -> bool:
    appt = db.query(Appointment).filter(Appointment.id == appt_id).first()
    if not appt:
        return False
    db.delete(appt)
    db.commit()
    return True
