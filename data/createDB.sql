-- TODO Etape 2 : créer les tables de la nouvelle base (schéma relationnel de la question 3)
DROP TABLE IF EXISTS ListeBV;
DROP TABLE IF EXISTS BureauVote;
DROP TABLE IF EXISTS Liste;
DROP TABLE IF EXISTS Commune;
DROP TABLE IF EXISTS Departement;

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
)

CREATE TABLE ListeBV(
    codeCommune VARCHAR NOT NULL,
    codeBV INTEGER NOT NULL,
    numPanneau INTEGER NOT NULL,
    voix INTEGER NOT NULL,
    PRIMARY KEY (CodeCommune, codeBV, numPanneau),
    CONSTRAINT voixLimit CHECK(voix >= 0),
    CONSTRAINT fk_codeCommune FOREIGN KEY (codeCommune) REFERENCES Commune(codeCommune),
    CONSTRAINT fk_codeBV FOREIGN KEY (codeBV) REFERENCES BureauVote(codeBV),
    CONSTRAINT fk_numPanneau FOREIGN KEY (numPanneau) REFERENCES Liste(numPanneau)

)

-- TODO Etape 4 : créer les vues

-- BureauxDetails : chaque bureau (identifié comme dans votre schéma) avec ses inscrits, votants, abstentions, blancs, nuls, exprimés et sa participation (0,5 point).




-- TODO Etape 5 : créer les triggers

-- summation voix <= inscrits
-- summation voix par bv = exprimes 

-- TODO Etape 6 : créer les index
