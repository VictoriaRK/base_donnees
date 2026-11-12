-- La table de travail V0 contient une ligne par bureau de vote, reprise telle quelle du fichier CSV
-- (sans les résultats des listes).
CREATE TABLE V0_Bureaux
(
  codeDepartement TEXT,
  libelleDepartement TEXT,
  codeCommune TEXT,
  libelleCommune TEXT,
  codeBV TEXT,
  inscrits INTEGER,
  votants INTEGER,
  pctVotants TEXT,
  abstentions INTEGER,
  exprimes INTEGER,
  blancs INTEGER,
  nuls INTEGER,
  CONSTRAINT V0_BU_CK1 CHECK (inscrits >= 0 AND votants >= 0)
);
