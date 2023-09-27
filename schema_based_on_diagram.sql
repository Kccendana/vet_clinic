createdb clinic;

CREATE TABLE medical_histories (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  admittrd_at timestamp,
  patient_id int,
  status varchar
);

CREATE TABLE patients (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar,
  date_of_birth date
);

CREATE TABLE invoices (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  total_amount decimal,
  generated_at timestamp,
  payed_at timestamp,
  medical_history_id int
);

CREATE TABLE invoice_items (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  unit_price decimal,
  quantity int,
  total_price decimal,
  invoice_id int,
  treatment_id int
);

CREATE TABLE treatments (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type varchar,
  name varchar
);

ALTER TABLE medical_histories ADD FOREIGN KEY (patient_id) REFERENCES  patients  ( id );

ALTER TABLE  medical_histories  ADD FOREIGN KEY ( id ) REFERENCES  invoices  ( medical_history_id );

ALTER TABLE  invoice_items  ADD FOREIGN KEY ( invoice_id ) REFERENCES  invoices  ( id );

ALTER TABLE  invoice_items  ADD FOREIGN KEY ( treatment_id ) REFERENCES  treatments  ( id );

CREATE TABLE  medical_histories_treatments  (
   medical_histories_id  int,
   treatments_id  int,
  PRIMARY KEY ( medical_histories_id ,  treatments_id ),
  FOREIGN KEY ( medical_histories_id ) REFERENCES  medical_histories  ( id );
  FOREIGN KEY ( treatments_id ) REFERENCES  treatments  ( id );
);

-- Add Index to foreign key
CREATE INDEX idx_fk_medical_histories_patient_id ON medical_histories (patient_id);
CREATE INDEX idx_fk_medical_histories_medical_history_id ON medical_histories (medical_history_id);
CREATE INDEX idx_fk_invoice_items_invoice_id ON invoice_items (invoice_id);
CREATE INDEX idx_fk_invoice_items_treatment_id ON invoice_items (treatment_id);
CREATE INDEX idx_fk_medical_histories_treatments_medical_histories_id ON medical_histories_treatments (medical_histories_id);
CREATE INDEX idx_fk_medical_histories_treatments_treatments_id ON medical_histories_treatments (treatments_id);
