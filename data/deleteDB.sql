-- TODO : supprimer aussi les vues, triggers et tables de la nouvelle base (dans le bon ordre)
DROP TABLE IF EXISTS V0_Bureaux;
DROP TABLE IF EXISTS ListeBv;
DROP TABLE IF EXISTS BureauVote;
DROP TABLE IF EXISTS Liste;
DROP TABLE IF EXISTS Commune;
DROP TABLE IF EXISTS Departement;

DROP VIEW IF EXISTS BureauxDetails;
DROP VIEW IF EXISTS ParticipationDepartements;
DROP VIEW IF EXISTS ResultatsDepartements;
DROP VIEW IF EXISTS BureauxForteParticipation;
