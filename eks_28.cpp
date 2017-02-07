//   Fil:  FRODEH \ OO \ EKSEMPEL \ EKS_28.CPP

//   Programeksempel nr.28 for forelesning i  C++ -programmering.


//   Eksemplet omhandler hvordan h�ndtere kommandolinje argumenter
//   som input til programmet (main). Programmet skj�ter sammen
//   (konkatenerer) de filene som kommer som input.


#include <iostream>                    //  cout
#include <fstream>                     //  ifstream, ofstream

using namespace std;

const int STRMAX = 200;                //  Max.tegn p� en linje.

int main(int argc, char* argv[])  {    //  HOVEDPROGRAM:
  ifstream innfil;
  ofstream utfil;
  int i;
  char buffer[STRMAX];

  if (argc >= 3)  {                  //  MINST 3 parametre (inkl.programnavn).
     utfil.open(argv[1], ios::app);  //  Pr�ver � �pne 1.fil.
     if (utfil)  {                   //  ��pning av outputfil gikk bra:
				                     //  Sjekker om de andre filene finnes:
	for (i = 2;  i < argc;  i++)  {
	    innfil.open(argv[i]);        //  Pr�ver � �pne filen.

	    if (!innfil)  {              //  Filen finnes ikke:
	       cout << "\n\nFilen  '" << argv[i] << "'  finnes ikke. "
		    << "Umulig � foreta konkateneringen.\n\n\n";
	       return 1;                 //  G�r rett ut til DOS igjen.
	    }
	    innfil.close();              //  Lukker filen.
	}
	//  VET HER AT ALLE FILENE SOM SKAL KONKATENERES VIRKELIG FINNES !

	cout << "\n\nFilen\t'" << argv[1] << "'   konkateneres med:";
	for (i = 2;  i < argc;  i++)  {
	    innfil.open(argv[i]);              // ŏpner filen.
	    cout << "\n\t'" << argv[i] << "'"; // Skriver filnavn til skjerm:
	    innfil.get(buffer, STRMAX);        // Henter (om mulig) 1.linje.
	    while (!innfil.eof())  {           // Looper til filslutt.
	       utfil << buffer << '\n';        // Skriver til outputfil.
	       innfil.ignore();                // Forkaster '\n' fra filen.
	       innfil.get(buffer, STRMAX);     // Henter (om mulig) ny linje.
	    }
	    innfil.close();                    // Lukker filen.
	}

     } else                                //  Klarte ikke � �pne outputfilen:
       cout << "\n\nFilen  '" << argv[1] << "'  finnes ikke. "
	    << "Umulig � foreta konkateneringen.";
     utfil.close();
  } else                                   //  For f� parametre:
    cout << "\n\n" << argv[0] << " skj�ter sammen (konkatenerer) de "
	 << "medsendte filene. Det m�\nmedsendes MINST to parametre. "
	 << "Den f�rste filen vil inneholde resultatet.\n\n"
	 << "\tSyntaks:   " << argv[0]
	 << "  <fil1>  <fil2>  [<fil3>  ...  <filN>]";
  cout << "\n\n\n";
  return 0;
}
