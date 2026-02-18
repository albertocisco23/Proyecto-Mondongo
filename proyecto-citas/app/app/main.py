import os
from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from .db import SessionLocal, Base, engine
from .schemas import AppointmentCreate, AppointmentOut
from .crud import create_appointment, list_appointments, delete_appointment

ADMIN_TOKEN = os.getenv("ADMIN_TOKEN", "changeme")

app = FastAPI(title="Portal de Citas - Centro Médico", version="1.0.0")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/api/appointments", response_model=AppointmentOut)
def api_create_appointment(payload: AppointmentCreate, db: Session = Depends(get_db)):
    try:
        return create_appointment(db, payload)
    except IntegrityError:
        raise HTTPException(status_code=409, detail="Ya existe una cita en esa franja horaria.")

def require_admin(x_admin_token: str | None):
    if x_admin_token != ADMIN_TOKEN:
        raise HTTPException(status_code=401, detail="No autorizado")

@app.get("/api/appointments", response_model=list[AppointmentOut])
def api_list_appointments(
    db: Session = Depends(get_db),
    x_admin_token: str | None = Header(default=None),
):
    require_admin(x_admin_token)
    return list_appointments(db)

@app.delete("/api/appointments/{appt_id}")
def api_delete_appointment(
    appt_id: int,
    db: Session = Depends(get_db),
    x_admin_token: str | None = Header(default=None),
):
    require_admin(x_admin_token)
    ok = delete_appointment(db, appt_id)
    if not ok:
        raise HTTPException(status_code=404, detail="Cita no encontrada")
    return {"deleted": True}
