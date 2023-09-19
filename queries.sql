/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon' ;

SELECT name from animals WHERE date_of_birth BETWEEN  '2016-01-01' and '2019-12-31' ;

SELECT name from animals WHERE neutered = TRUE  AND escape_attempts < 3 ;

SELECT date_of_birth from animals WHERE name IN ('Agumon', 'Pikachu') ;

SELECT name, escape_attempts from animals WHERE weight_kg > 10.5 ;

SELECT * from animals WHERE neutered = TRUE ;

SELECT * from animals WHERE name != 'Gabumon' ;

SELECT * from animals WHERE weight_kg BETWEEN  10.4 and 17.3 ;

/*Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.*/
BEGIN;
UPDATE animals SET species = 'unspecified' ;

SELECT * FROM animals ;
ROLLBACK;

SELECT * FROM animals ;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals ;
COMMIT;
SELECT * FROM animals ;

/*INSIDE A TRANSACTION DELETE ALL RECORDS*/
BEGIN;
DELETE FROM animals;
SELECT * FROM animals ;
ROLLBACK;
SELECT * FROM animals ;

/*INSIDE A TRANSACTION DELETE ANIMALS BORN AFTER JAN 1,2022*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT ANBORNAFTERJAN12022;

/*Update all animals' weight to be their weight multiplied by -1 THEN ROLLBACK TO SAVEPOINT*/
UPDATE animals SET weight_kg = weight_kg * -1 ;
ROLLBACK TO ANIMALBORNAFTERJAN12022;

/*Update all animals' weights that are negative to be their weight multiplied by -1.*/
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals ;

SELECT COUNT(*) AS animal_count FROM animals;
SELECT COUNT(*) AS have_not_escaped FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) AS animals_average_weight FROM animals;
SELECT neutered, SUM(escape_attempts) AS total_escaped_attempts FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) AS average_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;