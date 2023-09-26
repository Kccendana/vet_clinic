/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id serial PRIMARY KEY,
    name varchar(100),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(5,2)
);

ALTER TABLE animals ADD species varchar(255);

CREATE TABLE owners (
    id serial PRIMARY KEY,
    full_name varchar(255),
    age INTEGER
);

CREATE TABLE species (
    id serial PRIMARY KEY,
    name varchar(255)
);

ALTER TABLE animals
    DROP species,
    ADD COLUMN species_id INTEGER,
    ADD COLUMN owner_id INTEGER;

ALTER TABLE animals
    ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id),
    ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets (
    id serial PRIMARY KEY,
    name varchar(255),
    age INTEGER,
    date_of_graduation DATE
);

CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id),
    PRIMARY KEY(vet_id, species_id)
);

CREATE TABLE visits (
    id serial PRIMARY KEY,
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
    date_of_visit DATE
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);