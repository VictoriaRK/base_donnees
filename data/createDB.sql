-- TODO Etape 2 : créer les tables de la nouvelle base (schéma relationnel de la question 3)
CREATE TABLE Departement
(
    codeDepartement VARCHAR(5) PRIMARY KEY NOT NULL,
    libelleDepartement VARCHAR NOT NULL
);

CREATE TABLE Commune(
    codeCommune VARCHAR PRIMARY KEY NOT NULL,
    libelleCommune VARCHAR NOT NULL,
    codeDepartement VARCHAR(5) NOT NULL,
    CONSTRAINT fk_dep FOREIGN KEY (codeDepartement) REFERENCES Departement(codeDepartement)
);

CREATE TABLE Liste(
    numPanneau INTEGER PRIMARY KEY NOT NULL,
    nuance VARCHAR(4) NOT NULL,
    libelleAbregeListe VARCHAR,
    libelle VARCHAR,
    sieges INTEGER NOT NULL,
    CONSTRAINT numPanneauLimit 
        CHECK(numPanneau >= 1 AND numPanneau <= 38),
    CONSTRAINT nbSiege 
        CHECK(sieges >= 0)
);

CREATE TABLE BureauVote(
    codeCommune VARCHAR NOT NULL,
    codeBV INTEGER NOT NULL,
    inscrits INTEGER NOT NULL,
    votants INTEGER NOT NULL, -- summation de voix dans ListeBV
    blancs INTEGER NOT NULL,
    nuls INTEGER NOT NULL,
    PRIMARY KEY (codeCommune, codeBV),
    CONSTRAINT positive CHECK(inscrits >= 0 AND votants >= 0 AND blancs >= 0 AND nuls >= 0),
    CONSTRAINT limitsAdd CHECK (votants <= inscrits AND blancs+nuls <= votants),
    CONSTRAINT fk_codeCommune FOREIGN KEY (codeCommune) REFERENCES Commune(codeCommune)
);

CREATE TABLE ListeBV(
    codeCommune VARCHAR NOT NULL,
    codeBV INTEGER NOT NULL,
    numPanneau INTEGER NOT NULL,
    voix INTEGER NOT NULL,
    PRIMARY KEY (CodeCommune, codeBV, numPanneau),
    CONSTRAINT voixLimit CHECK(voix >= 0),
    CONSTRAINT fk_codeCommune FOREIGN KEY (codeCommune,codeBV) REFERENCES BureauVote(codeCommune,codeBV),
    CONSTRAINT fk_numPanneau FOREIGN KEY (numPanneau) REFERENCES Liste(numPanneau)

);

-- TODO Etape 4 : créer les vues

-- BureauxDetails : chaque bureau (identifié comme dans votre schéma) avec ses inscrits, votants, abstentions, blancs, nuls, exprimés et sa participation (0,5 point).


CREATE VIEW BureauxDetails AS
SELECT codeCommune,codeBV,inscrits, votants, (inscrits - votants) AS absentions, blancs, nuls, (votants - (blancs + nuls)) AS exprimés, ROUND((votants * 100.0) / NULLIF(inscrits,0) , 2) AS participation
FROM BureauVote;



-- ParticipationDepartements (code, libelle, inscrits, votants, participation) : la participation de chaque département (0,5 point).

CREATE VIEW ParticipationDepartements AS
SELECT D.codeDepartement AS code, D.libelleDepartement AS libelle, SUM(BV.inscrits) AS inscrits, SUM(BV.votants) AS votants, ROUND((SUM(BV.votants)* 100.0 )/ NULLIF(SUM(BV.inscrits),0) , 2) AS participation
FROM Departement AS D JOIN (
    BureauVote AS BV JOIN Commune AS C
    ON BV.codeCommune = C.codeCommune
) AS BC 
ON D.codeDepartement = BC.codeDepartement
GROUP BY D.codeDepartement;

-- ResultatsDepartements (codeDepartement, numListe, libelleAbrege, nbVoix, pctExprimes) : les voix de chaque liste dans chaque département, et leur pourcentage des exprimés du département (0,5 point).

CREATE VIEW ResultatsDepartements AS 
WITH ExprimesDepartements AS (
    SELECT C.codeDepartement AS codeDepartement, SUM(BD.exprimés) AS exprimés
    FROM Commune C JOIN BureauxDetails BD ON (C.codeCommune = BD.codeCommune)
    GROUP BY C.codeDepartement
),
VoixDepartements AS (
    SELECT C.codeDepartement AS codeDepartement, LBV.numPanneau AS numPanneau, SUM(LBV.voix) as nbVoix
    FROM ListeBV LBV JOIN Commune C ON (C.codeCommune = LBV.codeCommune)
    GROUP BY C.codeDepartement, LBV.numPanneau
)
SELECT ED.codeDepartement AS codeDepartement, VD.numPanneau AS numListe, L.libelleAbregeListe AS libelleAbrege, VD.nbVoix AS nbVoix, ROUND(100.0 *(VD.nbVoix / ED.exprimés), 2) AS pctExprimes
FROM ExprimesDepartements ED JOIN VoixDepartements VD ON (ED.codeDepartement = VD.codeDepartement)
JOIN Liste L ON (VD.numPanneau = L.numPanneau);


-- BureauxForteParticipation : les bureaux (identifi´es comme dans votre sch´ema), avec leur participation, dont la participation d´epasse la participation nationale (le total des votants divis´e par le total des inscrits) (0,5 point).


-- ListesEnTete (codeDepartement, numListe, libelleAbrege, nbVoix) : la liste arriv´ee en tˆete dans chaque d´epartement (en cas d’´egalit´e, toutes les listes `a ´egalit´e) (0,5 point).
-- nbVoix = MAX(nbVoix)

-- ListesPartout (num, libelleAbrege) : les listes qui ont obtenu au moins une voix dans chaque d´epartement (1 point).
-- On somme les voix par (département, liste), on garde celles > 0, puis COUNT(DISTINCT département) par liste doit égaler le nombre de lignes de Departements. L'option b exigerait une voix dans chaque bureau, ce qui est beaucoup plus strict que dans chaque département.

-- ResultatsDepartements (codeDepartement, numListe, libelleAbrege, nbVoix, pctExprimes) 
CREATE VIEW ResultatsDepartements AS
SELECT D.code AS codeDepartement, B.numPanneau AS numListe,
L.libelleAbregeListe AS libelleAbrege,SUM(B.voix) AS nbvoix,ROUND(100.0*SUM(B.voix)/NULLIF(SUM(BD.exprimés),0),2) AS pctExprimes
FROM ParticipationDepartements D
JOIN Commune C ON D.code=C.codeDepartement
JOIN ListeBV B ON B.codeCommune=C.codeCommune
JOIN BureauxDetails BD ON BD.codeCommune= B.codeCommune AND BD.codeBV=B.codeBV
JOIN Liste L ON L.numPanneau=B.numPanneau
GROUP BY D.code,B.numPanneau;

-- BureauxForteParticipation : les bureaux (identifiés comme dans votre schéma), avec leur
--participation, dont la participation dépasse la participation nationale (le total des votants
--divisé par le total des inscrits)
CREATE VIEW BureauxForteParticipation AS
SELECT BD.codeCommune,BD.codeBV,BD.participation
FROM BureauxDetails BD 
WHERE BD.participation> (SELECT 1.0 *SUM(votants)/SUM(inscrits) FROM BureauVote);

-- TODO Etape 5 : créer les triggers

-- summation voix <= inscrits
-- summation voix par bv = exprimes 

-- TODO Etape 6 : créer les index
