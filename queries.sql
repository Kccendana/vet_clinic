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
SELECT * FROM animals ;

/*Update all animals' weight to be their weight multiplied by -1 THEN ROLLBACK TO SAVEPOINT*/
UPDATE animals SET weight_kg = weight_kg * -1 ;
ROLLBACK TO ANIMALBORNAFTERJAN12022;
SELECT * FROM animals ;

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

SELECT name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';

SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';

SELECT owners.full_name, COALESCE(array_agg(animals.name), '{}':: VARCHAR[]) AS animals_owned 
FROM owners 
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name;

SELECT species.name AS species_name, COUNT(*) AS animal_count FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;

SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(*) AS animal_count FROM owners JOIN animals ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY animal_count DESC LIMIT 1;

/*last animal seen by William Tatcher*/
SELECT animals.name AS last_seen FROM animals JOIN visits ON animals.id = visits.animal_id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY visits.date_of_visit DESC LIMIT 1; 

/*How many different animals Mendex see?*/
SELECT COUNT(DISTINCT animals.id) AS animal_seen
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez';

/*List of vets and their specialization*/
SELECT vets.name AS name, species.name AS specialization 
FROM vets 
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

/*animal visited by Mendez april 1 -augu 30,2020*/
SELECT animals.name AS animal_seen
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT animals.name AS most_visits, COUNT(visits.id) AS visit_count 
FROM animals 
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.id ORDER BY visit_count DESC LIMIT 1;

SELECT animals.name AS first_visited, MIN(visits.date_of_visit) AS first_visited_date
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'
GROUP BY animals.name
ORDER BY first_visited_date LIMIT 1;

/*Recent Visited*/
SELECT animals.name AS animal_name, vets.name AS vet_name, visits.date_of_visit
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
ORDER BY visits.date_of_visit DESC LIMIT 1;

/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT COUNT(*) AS visit_count_of_unspecialized
FROM visits
JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON vets.id = specializations.vet_id
WHERE specializations.species_id IS NULL;

/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT species.name AS species_name, COUNT(*) AS visit_count
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
LEFT JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY visit_count DESC LIMIT 1;
