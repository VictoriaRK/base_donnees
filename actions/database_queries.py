# Fonction permettant d'afficher la participation dans les bureaux de vote d'une commune donnée par son nom
def participation_commune(data, commune):
    print("\nParticipation dans les bureaux de vote de " + commune + " :")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT codeCommune, libelleDepartement, codeBV, inscrits, votants, pctVotants
                FROM V0_Bureaux
                WHERE libelleCommune = ?
                ORDER BY codeCommune, codeBV
            """,
            [commune])
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for bureau in result:
            print(bureau[0] + " (" + bureau[1] + ") bureau " + bureau[2] + " : "
                  + str(bureau[4]) + " votants sur " + str(bureau[3]) + " inscrits (" + bureau[5] + ")")
